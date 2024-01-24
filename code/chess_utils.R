csv_list_to_vec = function(character_list, numeric=FALSE)
{
  if(numeric==TRUE){
    vector = as.numeric(unlist(strsplit(gsub("\\]", "", gsub("\\[", "", character_list)), ", ")))
  }else{
    vector = strsplit(gsub("\\]", "", gsub("\\[", "", character_list)), ", ")
  }
  return(vector)
}

evaluation = "[30, 36, -5, 200, 214, 99]"
evaluation
# to vector:
csv_list_to_vec(evaluation, numeric=TRUE)
