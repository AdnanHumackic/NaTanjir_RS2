using MapsterMapper;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.BaseServices.Implementation
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual TModel Insert(TInsert request)
        {

            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);
            Context.Add(entity);
            Context.SaveChanges();
            AfterInsert(request, entity);

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }
        public virtual void AfterInsert(TInsert request, TDbEntity entity) { }

        public virtual TModel Update(int id, TUpdate request)
        {
            var set = Context.Set<TDbEntity>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            Context.SaveChanges();

            AfterUpdate(request, entity);

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
        public virtual void AfterUpdate(TUpdate request, TDbEntity entity) { }

        public virtual void Delete(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);
            if (entity == null)
            {
                throw new Exception("Unesite postojeći id.");
            }

            if (entity is ISoftDelete softDeleteEntity)
            {
                softDeleteEntity.IsDeleted = true;
                softDeleteEntity.VrijemeBrisanja = DateTime.Now;
                Context.Update(entity);
            }
            else
            {
                Context.Remove(entity);
            }

            Context.SaveChanges();
        }
    }
}
