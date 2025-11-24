const admin = require('firebase-admin');
const fs = require("fs");

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function run() {
  const json = JSON.parse(fs.readFileSync("backend/menu.json", "utf8"));

  const menu = json.menu;

  console.log(`Importando ${menu.length} registros de 'menu'...`);


  for (const item of menu) {
    await db.collection("menu").add(item); 
    console.log(`-> Registro "${item.title}" importado`);
  }

  console.log("Finalizado.");
}

run();
