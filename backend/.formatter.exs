[
  import_deps: [:ecto, :phoenix, :commanded, :absinthe],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  locals_without_parens: [
    project: 2,
    project: 3,
    validates: 2,
    assert_error: 2,
    assert_contain_exactly: 2,
    assert_contain_exactly: 3,
    assert_lists_equal: 2,
    assert_lists_equal: 3
  ]
]
