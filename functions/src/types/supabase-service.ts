import { Template } from "./template";

interface ISupabaseServices {
  getTemplate(id: string): Promise<Template>;
  deleteUser(uid: string): Promise<void>;
}

export { ISupabaseServices };
