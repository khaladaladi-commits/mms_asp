namespace MMS.Models;

public class File
{
    public int Id { get; set; }
    public string Type { get; set; } = "mandatory";
    public int MmId { get; set; }
    public string? Code { get; set; }
    public int MetricId { get; set; }
    public string Filename { get; set; } = string.Empty;
    public string OriginalName { get; set; } = string.Empty;
    public string Status { get; set; } = "pending_sh";
    public int UploadedBy { get; set; }
    public DateTime CreatedAt { get; set; }
}
