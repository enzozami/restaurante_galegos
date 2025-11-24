const admin = require('firebase-admin');
const fs = require("fs");

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/sobre.json", "utf8"));

  const sobreNosList = json.sobre_nos;

  console.log(`Importando ${sobreNosList.length} registros de 'sobre nós'...`);


  for (const item of sobreNosList) {
    await db.collection("sobre_nos").add(item); 
    console.log(`-> Registro "${item.title}" importado`);
  }

  console.log("Finalizado.");
}

run();
