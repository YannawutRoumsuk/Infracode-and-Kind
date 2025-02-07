import express, { Express, Request, Response, Application } from "express";
import dotenv from "dotenv";

//For env File
dotenv.config();

const app: Application = express();
const port = process.env.PORT || 3000;

app.get("/", (req: Request, res: Response) => {
  console.log("Request received path /");
  res.send("Welcome to Express & TypeScript Server");
});

app.get("/health", (req: Request, res: Response) => {
  console.log("Request received path /health");
  res.send("health ok");
});

app.get("/ready", (req: Request, res: Response) => {
  console.log("Request received path /ready");
  res.send("readiness ok");
});

app.listen(port, () => {
  console.log(`Server is Fire at http://0.0.0.0:${port}`);
});
