[
  import_deps: [:ecto, :phoenix, :commanded, :absinthe],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  locals_without_parens: [project: 2, project: 3, validates: 2]
]
