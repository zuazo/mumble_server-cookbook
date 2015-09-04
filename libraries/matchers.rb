if defined?(ChefSpec)

  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :mumble_server_supw
  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :mumble_server_supw
  end

  def change_mumble_server_supw(password)
    ChefSpec::Matchers::ResourceMatcher.new(
      :mumble_server_supw, :change, password
    )
  end

end
