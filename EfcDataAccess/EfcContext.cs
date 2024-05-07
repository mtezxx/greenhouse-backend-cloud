using Domain.Entity;
using Microsoft.EntityFrameworkCore;

namespace EfcDataAccess;

public class EfcContext : DbContext
{
    public DbSet<User> Users { get; set; }

    public EfcContext(DbContextOptions<EfcContext> options) : base(options)
    {
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlite("Data Source = ../EfcDataAccess/Greenhouse.db");
            optionsBuilder.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().HasKey(user => user.Id);
    }
}