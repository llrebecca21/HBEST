gen_data = function(gen_method, ...){
  gen_method = match.arg(gen_method, c("ARp", "AR1vary", "AR2mix", "MA4","MA4vary","MA4varyType2"))
  # Extract call parameters:
  Call = c(as.list(environment()), list(...))
  
  Send_Call = switch(gen_method,
                     ARp = formals(generate_AR),
                     AR1vary = formals(generate_AR1_vary),
                     AR2mix = formals(generate_AR2_mixture),
                     MA4vary = formals(generate_MA4_vary),
                     MA4 = formals(generate_MA4),
                     MA4varyType2 = formals(generate_MA4_varyType2),
                     stop("Invalid `gen_method` value"))
  
  Send_Call[names(Call)[names(Call) %in% names(Send_Call)]] = Call[names(Call) %in% names(Send_Call)]
  
  out = switch(gen_method,
               ARp = do.call(generate_AR, args = Send_Call),
               AR1vary = do.call(generate_AR1_vary, args = Send_Call),
               AR2mix = do.call(generate_AR2_mixture, args = Send_Call),
               MA4vary = do.call(generate_MA4_vary, args = Send_Call),
               MA4 = do.call(generate_MA4, args = Send_Call),
               MA4varyType2 = do.call(generate_MA4_varyType2, args = Send_Call),
               stop("Invalid `gen_method` value"))
  
  return(out)
  
}






