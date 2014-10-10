if defined?(ChefSpec)

  def change_mumble_server_supw(password)
    ChefSpec::Matchers::ResourceMatcher.new(
      :mumble_server_supw, :change, password
    )
  end

end
