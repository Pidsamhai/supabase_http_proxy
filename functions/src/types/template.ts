export interface Template {
    baseUrl: string
    name: string
    descriptions: string
    headers: Record<string, string>
    params: Record<string, string>
}
