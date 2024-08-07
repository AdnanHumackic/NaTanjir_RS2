using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Interfaces;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.BaseServices.Implementation
{
    public class BaseServiceAsync<TModel, TSearch, TDbEntity> : IServiceAsync<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public NaTanjirContext Context { get; }
        public IMapper Mapper { get; }

        public BaseServiceAsync(NaTanjirContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public async Task<PagedResult<TModel>> GetPagedAsync(TSearch search, CancellationToken cancellationToken = default)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(search, query);

            int count = await query.CountAsync(cancellationToken);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);
            result = Mapper.Map(list, result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();

            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }
        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
        public async Task<TModel> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Set<TDbEntity>().FindAsync(id, cancellationToken);

            if (entity != null)
            {
                return Mapper.Map<TModel>(entity);
            }
            else
            {
                return null;
            }
        }
    }
}
