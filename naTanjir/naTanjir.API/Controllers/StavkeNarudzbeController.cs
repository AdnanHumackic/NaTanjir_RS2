using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class StavkeNarudzbeController:BaseCRUDController<Model.StavkeNarudzbe, StavkeNarudzbeSearchObject, StavkeNarudzbeInsertRequest, StavkeNarudzbeUpdateRequest>
    {
        protected IStavkeNarudzbe _service;

        public StavkeNarudzbeController(IStavkeNarudzbe service)
            : base(service)
        {
        }
    }
}
