using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.SearchObject;
using naTanjir.Model;
using Microsoft.AspNetCore.Authorization;
using naTanjir.Services.BaseServices.Interfaces;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class BaseController<TModel, TSearch>:ControllerBase  where TSearch : BaseSearchObject
    {
        protected IService<TModel, TSearch> _service;
        public BaseController(IService<TModel, TSearch> service)
        {
            
            _service = service;
        }
        [HttpGet]
        public virtual PagedResult<TModel> GetList([FromQuery] TSearch search)
        {
            return _service.GetPaged(search);
        }

        [HttpGet("{id}")]
        public virtual TModel GetById(int id)
        {
            return _service.GetById(id);
        }
    }
}
