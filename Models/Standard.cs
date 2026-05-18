namespace MMS.Models;

public class Standard
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int OrderNum { get; set; }
    public DateTime CreatedAt { get; set; }
    public ICollection<Metric> Metrics { get; set; } = new List<Metric>();
}
