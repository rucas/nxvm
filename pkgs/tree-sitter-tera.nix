{ inputs, tree-sitter }:
tree-sitter.buildGrammar {
  pname = "tree-sitter-tera";
  language = "tera";
  version = inputs.tree-sitter-tera.shortRev;
  src = inputs.tree-sitter-tera;
}
