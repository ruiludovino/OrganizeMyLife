const {onSchedule} = require("firebase-functions/v2/scheduler");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

/**
 * Todos os dias às 08:00 (Europe/Lisbon), varre as tarefas de todos os
 * usuários e manda um push para quem tem pelo menos uma tarefa vencida ou
 * que vence hoje. Complementa os lembretes locais (que só cobrem o que o
 * próprio usuário agendou explicitamente): tarefas nunca tinham nenhum
 * aviso antes disto.
 */
exports.dailyTaskDigest = onSchedule(
  {schedule: "every day 08:00", timeZone: "Europe/Lisbon"},
  async () => {
    const endOfToday = new Date();
    endOfToday.setHours(23, 59, 59, 999);

    const snapshot = await db
      .collectionGroup("tasks")
      .where("dueDate", "<=", admin.firestore.Timestamp.fromDate(endOfToday))
      .get();

    const dueCountByUser = new Map();
    for (const doc of snapshot.docs) {
      const data = doc.data();
      if (data.done) continue;
      const userId = doc.ref.parent.parent.id;
      dueCountByUser.set(userId, (dueCountByUser.get(userId) ?? 0) + 1);
    }

    logger.info(`dailyTaskDigest: ${dueCountByUser.size} usuário(s) com tarefas pendentes`);

    await Promise.all(
      Array.from(dueCountByUser.entries()).map(([userId, count]) =>
        notifyUser(userId, count),
      ),
    );
  },
);

async function notifyUser(userId, count) {
  const userDoc = await db.collection("users").doc(userId).get();
  const tokens = userDoc.data()?.fcmTokens ?? [];
  if (tokens.length === 0) return;

  const response = await messaging.sendEachForMulticast({
    tokens,
    notification: {
      title: "OrganizeMyLife",
      body: count === 1 ?
        "Tens 1 tarefa pendente para hoje." :
        `Tens ${count} tarefas pendentes para hoje.`,
    },
  });

  // Tokens que falharam por já não serem válidos (app desinstalada, etc.)
  // — removemos para não acumular lixo e não pagar envios inúteis.
  const invalidTokens = response.responses
    .map((result, i) => (result.success ? null : tokens[i]))
    .filter((token) => token !== null);

  if (invalidTokens.length > 0) {
    await db.collection("users").doc(userId).update({
      fcmTokens: admin.firestore.FieldValue.arrayRemove(...invalidTokens),
    });
  }
}
