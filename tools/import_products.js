const admin = require('firebase-admin');
const fs = require("fs"); 

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/products.json", "utf8"));

  const products = json.products;

  console.log(`Importando ${products.length} produtos...`);

  for (const p of products) {
    await db.collection("products").doc(p.id.toString()).set(p);
    console.log(`-> Produto ${p.id} importado`);
  }

  console.log("Finalizado.");
}

run();
