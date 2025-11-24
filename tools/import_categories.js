const admin = require('firebase-admin');
const fs = require("fs"); 

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/categories.json", "utf8"));

  const categories = json.categories;

  console.log(`Importando ${categories.length} produtos...`);

  for (const category of categories) {
    await db.collection("categories").add(category);
    console.log(`-> Categoria ${category.name} importado`);
  }

  console.log("Finalizado.");
}

run();
