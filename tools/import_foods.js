const admin = require('firebase-admin');
const fs = require("fs"); 

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/alimentos.json", "utf8"));

  const foods = json.alimentos;

  console.log(`Importando ${foods.length} produtos...`);

  for (const food of foods) {
    await db.collection("foods").doc(food.id.toString()).set(food);
    console.log(`-> Alimento ${food.id} importado`);
  }

  console.log("Finalizado.");
}

run();
