import Server from "./server";
import * as dotenv from "dotenv";
import route from "./route";

dotenv.config();
const port = process.env.PORT || 9000;

const server = Server(route);
server.listen(port, () => {
  console.log("\x1b[36m", `Live on http://127.0.0.1:${port}`);
});
