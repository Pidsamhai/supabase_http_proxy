import { CorsOptions } from "cors";
import client from "../supabase-client";
import { Cors } from "../types/cors";
import * as cors from "cors";

var deleteAccontCors: CorsOptions = {
  origin: async function (origin, callback) {
    console.log(origin + Date.now().toString());
    try {
      const cors = await client
        .from<Cors>("cors")
        .select("name,origins")
        .eq("name", "delete_account")
        .single();
      console.log(origin);
      if (!origin || cors.data?.origins.includes(origin) == true) {
        console.log("Passed Cors");
        callback(null, true);
      } else {
        callback(null, `${cors.data?.origins[0]}`);
      }
    } catch (error) {
      console.log(error);
      callback(null, "https://pidsamhai.github.io");
    }
  },
};

export default cors(deleteAccontCors);
