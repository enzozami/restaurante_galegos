const admin = require('firebase-admin');
const fs = require("fs"); 

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/ceps.json", "utf8"));

  const ceps = json.cep;

  console.log(`Importando ${ceps.length} ceps...`);

  for (const cep of ceps) {
    await db.collection("ceps").add(cep);
    console.log(`-> Cep ${cep} importado`);
  }

  console.log("Finalizado.");
}

run();
