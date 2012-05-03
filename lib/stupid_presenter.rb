module StupidPresenters
  class StupidPresenter
    attr_reader :model, :context

    def initialize(model, context, args = {})
      @model, @context = model, context
    end

    def method_missing(*args, &block)
      target =
        if model.respond_to?(args.first)
          model
        else
          context
        end
      target.send(*args, &block)
    end

    def present(&block)
      instance_eval(&block)
    end
  end
end
