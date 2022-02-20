import { ISupabaseServices as ISupabaseService } from "../types/supabase-service";
import { Template } from "../types/template";
import client from "../supabase-client";
import { TemplateNotFound, UserNotFound } from "../exception";

class SupabaseService implements ISupabaseService {
  async getTemplate(id: string): Promise<Template> {
    try {
      const doc = await client
        .from("template")
        .select("*")
        .eq("uid", id)
        .single();
      if (doc.data == null || doc.error != null) {
        throw new TemplateNotFound(id);
      }
      return <Template>doc.data;
    } catch (error) {
      throw error;
    }
  }
  async deleteUser(uid: string): Promise<void> {
    try {
      const result = await client.auth.api.deleteUser(uid);
      if (result.error != null) {
        throw new UserNotFound();
      }
      return;
    } catch (error) {
      throw error;
    }
  }
}

const supabaseService = new SupabaseService();

export { SupabaseService, supabaseService };
