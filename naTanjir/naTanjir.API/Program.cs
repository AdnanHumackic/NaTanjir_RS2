using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using naTanjir.API.Authentication;
using naTanjir.API.Filters;
using naTanjir.Services;
using naTanjir.Services.Auth;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Implementation;
using naTanjir.Services.Validator.Interfaces;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IProizvodiService, ProizvodiService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IVrstaProizvodumService, VrstaProizvodumService>();
builder.Services.AddTransient<IVrstaRestoranaService, VrstaRestoranaService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();
builder.Services.AddTransient<ILokacijaService, LokacijaService>();
builder.Services.AddTransient<IRestoranService, RestoranService>();
builder.Services.AddTransient<IRestoranFavoritService, RestoranFavoritService>();
builder.Services.AddTransient<IOcjenaRestoranService, OcjenaRestoranService>();
builder.Services.AddTransient<IOcjenaProizvodService, OcjenaProizvodService>();
builder.Services.AddTransient<INarudzbaService, NarudzbaService>();
builder.Services.AddTransient<IStavkeNarudzbe, StavkeNarudzbeService>();
builder.Services.AddTransient<IUpitService, UpitService>();

builder.Services.AddTransient<IUlogeValidatorService, UlogeValidatorService>();
builder.Services.AddTransient<IVrstaRestoranaValidatorService, VrstaRestoranaValidatorService>();
builder.Services.AddTransient<IVrstaProizvodumValidatorService, VrstaProizvodumValidatorService>();
builder.Services.AddTransient<IRestoranFavoritValidatorService, RestoranFavoritValidatorService>();
builder.Services.AddTransient<IRestoranValidatorService, RestoranValidatorService>();
builder.Services.AddTransient<IOcjenaRestoranValidatorService, OcjenaRestoranValidatorService>();
builder.Services.AddTransient<IOcjenaProizvodValidatorService, OcjenaProizvodValidatorService>();

builder.Services.AddTransient<IActiveUserService, ActiveUserService>();
builder.Services.AddTransient<IActiveUserServiceAsync, ActiveUserServiceAsync>();



builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});
var connectionString = builder.Configuration.GetConnectionString("naTanjirConnection");
builder.Services.AddDbContext<NaTanjirContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddHttpContextAccessor();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<NaTanjirContext>();
    //dataContext.Database.EnsureCreated();
    dataContext.Database.Migrate();

}

app.Run();
