class Module
  def attribute(*params, &block)
    return params[0].each { |p,v| attribute(p) {v} } if params[0].kind_of?(Hash)

    params.each { |param|
      define_method("__#{param}__", block) unless block.nil?
      class_eval %{
        attr_writer :#{param}

        def #{param}
          defined?(@#{param}) ? @#{param} : __#{param}__
        end

        def #{param}?
          (defined?(@#{param}) || defined?(__#{param}__)) && !#{param}.nil?
        end
      }
    }
  end
end