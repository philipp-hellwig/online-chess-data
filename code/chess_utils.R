csv_list_to_vec = function(
    character_list,
    numeric=FALSE
){
  if(numeric==TRUE){
    vector = as.numeric(unlist(strsplit(gsub("\\]", "", gsub("\\[", "", character_list)), ", ")))
  }else{
    vector = strsplit(gsub("\\]", "", gsub("\\[", "", character_list)), ", ")
  }
  return(vector)
}
