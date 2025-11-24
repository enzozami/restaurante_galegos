const admin = require('firebase-admin');
const fs = require("fs"); 

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/horario_funcionamento.json", "utf8"));

  const horarios = json.horarios;

  console.log(`Importando ${horarios.length} produtos...`);

  for (const horario of horarios) {
    await db.collection("horario_funcionamento").add(horario);
    console.log(`-> Alimento ${horario} importado`);
  }

  console.log("Finalizado.");
}

run();
