module Locomotive
  module Builder
    module Liquid
      module Tags

        class Snippet < ::Liquid::Include

          def render(context)
            source = context.registers[:mounting_point].snippets[@template_name].try(:source)

            partial = ::Liquid::Template.parse(source)

            variable = context[@variable_name || @template_name[1..-2]]

            context.stack do
              @attributes.each do |key, value|
                context[key] = context[value]
              end

              output = (if variable.is_a?(Array)
                variable.collect do |variable|
                  context[@template_name[1..-2]] = variable
                  partial.render(context)
                end
              else
                context[@template_name[1..-2]] = variable
                partial.render(context)
              end)

              output
            end
          end

        end

        ::Liquid::Template.register_tag('include', Snippet)
      end
    end
  end
end