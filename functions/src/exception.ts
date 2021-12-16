export class TemplateNotFound extends Error {
    constructor(id: string) {
        super();
        this.message = `Template ${id} not found`
    }
}