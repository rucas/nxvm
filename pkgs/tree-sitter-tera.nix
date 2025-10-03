{ inputs, tree-sitter }:
tree-sitter.buildGrammar {
  language = "tera";
  version = inputs.tree-sitter-tera.shortRev;
  src = inputs.tree-sitter-tera;
}
