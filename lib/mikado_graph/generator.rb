module MikadoGraph
  class Generator
    attr_accessor :dependencies

    def self.define(&block)
      generator_instance = new
      generator_instance.dependencies.instance_eval(&block)
      generator_instance
    end

    def initialize
      @dependencies = Dependencies.new
    end

    def generate
      convert(dependencies.dependent_states)
    end

    private

    def convert(states)
      convert_header
      convert_states_and_dependencies(states)
      convert_footer
    end

    def convert_header
      puts "digraph {"
      puts "  node [shape=box];"
      puts "  rankdir=\"LR\";"
    end

    def convert_states_and_dependencies(states)
      states.each { |state| convert_dependencies(state) }
    end

    def convert_dependencies(state)
      state.dependent_states.each do |dependent_state|
        convert_dependency(state, dependent_state)
        convert_dependencies(dependent_state)
      end
    end

    def convert_dependency(state, dependent_state)
      puts "  \"#{dependent_state.name}\" -> \"#{state.name}\";"
    end

    def convert_footer
      puts "}"
    end
  end
end
