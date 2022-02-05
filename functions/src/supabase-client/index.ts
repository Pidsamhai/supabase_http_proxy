import { createClient } from "@supabase/supabase-js";
import * as dotenv from "dotenv";

dotenv.config();

const SUPABASE_API_URL = process.env.SUPABASE_API_URL || "";
const SUPABASE_SECRET_KEY = process.env.SUPABASE_SECRET_KEY || "";

export default createClient(SUPABASE_API_URL, SUPABASE_SECRET_KEY);
