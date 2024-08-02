using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.SearchObject;
using naTanjir.Model;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseController<TModel, TSearch>:ControllerBase  where TSearch : BaseSearchObject
    {
        protected IService<TModel, TSearch> _service;
        public BaseController(IService<TModel, TSearch> service)
        {
            
            _service = service;
        }
        [HttpGet]
        public PagedResult<TModel> GetList([FromQuery] TSearch search)
        {
            return _service.GetPaged(search);
        }

        [HttpGet("{id}")]
        public TModel GetById(int id)
        {
            return _service.GetById(id);
        }
    }
}
