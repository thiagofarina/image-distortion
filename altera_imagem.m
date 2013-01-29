#
# Exemplo de como rodar o programa:
#
# source("altera_imagem.m");
# imagemTorta = imread("imagem_torta.jpg");
# imagemNormal = corrigeImagem(imagemTorta);
# imwrite(imagemNormal, "imagem_normal.jpg");
#

function imageSaida = AlteraImg(imagemEntrada)
  # Neste passo é realizado a criação da matriz (r, s). Nesta se utiliza a
  # imagem distorcida.
  MatDist = [ 56, 295;
              83, 264;
              45, 348;
              324, 459;
              426, 508;
              568, 245 ];

  # Neste passo é realizado a criação da matriz (u, v). Nesta se utiliza a
  # imagem de saída (sem distorção).
  MatOrig = [ 71, 184;
              117, 146;
              44, 264;
              435, 446;
              550, 510;
              620, 202 ];


  # Neste passo é realizado a criação da matriz A.
A = [MatOrig(1, 1), MatOrig(1, 2), 1, 0, 0, 0, - MatOrig(1, 1) * MatDist(1, 1), - MatOrig(1, 2) * MatDist(1, 1);
0, 0, 0, MatOrig(1, 1), MatOrig(1, 2), 1, - MatOrig(1, 1) * MatDist(1, 2), - MatOrig(1, 2) * MatDist(1, 2);
MatOrig(2, 1), MatOrig(2, 2), 1, 0, 0, 0, - MatOrig(2, 1) * MatDist(2, 1), - MatOrig(2, 2) * MatDist(2, 1);
0, 0, 0, MatOrig(2, 1), MatOrig(2, 2), 1, - MatOrig(2, 1) * MatDist(2, 2), - MatOrig(2, 2) * MatDist(2, 2);
MatOrig(3, 1), MatOrig(3, 2), 1, 0, 0, 0, - MatOrig(3, 1) * MatDist(3, 1), - MatOrig(3, 2) * MatDist(3, 1);
0, 0, 0, MatOrig(3, 1), MatOrig(3, 2), 1, - MatOrig(3, 1) * MatDist(3, 2), - MatOrig(3, 2) * MatDist(3, 2);
MatOrig(4, 1), MatOrig(4, 2), 1, 0, 0, 0, - MatOrig(4, 1) * MatDist(4, 1), - MatOrig(4, 2) * MatDist(4, 1);
0, 0, 0, MatOrig(4, 1), MatOrig(4, 2), 1, - MatOrig(4, 1) * MatDist(4, 2), - MatOrig(4, 2) * MatDist(4, 2);
MatOrig(5, 1), MatOrig(5, 2), 1, 0, 0, 0, - MatOrig(5, 1) * MatDist(5, 1), - MatOrig(5, 2) * MatDist(5, 1);
0, 0, 0, MatOrig(5, 1), MatOrig(5, 2), 1, - MatOrig(5, 1) * MatDist(5, 2), - MatOrig(5, 2) * MatDist(5, 2);
MatOrig(6, 1), MatOrig(6, 2), 1, 0, 0, 0, - MatOrig(6, 1) * MatDist(6, 1), - MatOrig(6, 2) * MatDist(6, 1);
0, 0, 0, MatOrig(6, 1), MatOrig(6, 2), 1, - MatOrig(6, 1) * MatDist(6, 2), - MatOrig(6, 2) * MatDist(6, 2)];


  # Neste passo é realizado a criação da matriz L a partiz dos pontos da MatDist.
  L = [ MatDist(1, 1), MatDist(1, 2),
        MatDist(2, 1), MatDist(2, 2),
        MatDist(3, 1), MatDist(3, 2),
        MatDist(4, 1), MatDist(4, 2),
        MatDist(5, 1), MatDist(5, 2),
        MatDist(6, 1), MatDist(6, 2) ];

  # Calculo pelo método dos Mínimos Quadrados.
  # x = (At * A) -¹ * At * L

  MatAux = A' * A;
  X = inv(MatAux) * A' * L;

  T(1, 1) = X(1, 1);
  T(1, 2) = X(2, 1);
  T(1, 3) = X(3, 1);
  T(2, 1) = X(4, 1);
  T(2, 2) = X(5, 1);
  T(2, 3) = X(6, 1);
  T(3, 1) = X(7, 1);
  T(3, 2) = X(8, 1);
  T(3, 3) = 1;

  whos
  numLinhas = rows(imagemEntrada)
  numColunas = columns(imagemEntrada)

  # Calcula os novos pontos na |imagemSaida|.
  for linha = 1: numLinhas
    for coluna = 1: numColunas
       aux = T * [linha; coluna; 1];
       resultado = [aux(1, 1, 1) / aux(3, 1, 1);
       aux(2, 1, 1) / aux(3, 1, 1);
       aux(3, 1, 1) / aux(3, 1, 1)];
       # Retorna o inteiro próximo de resultado(1, 1).
       w = round(resultado(1, 1));
       # Retorna o inteiro próximo de resultado(2, 1).
       z  = round(resultado(2, 1));
       if ((w >= 1) && (z >= 1) && (w <= numLinhas) && (z <= numColunas))
         imagemSaida(linha, coluna, 1) = imagemEntrada(w, z, 1);
       endif
     endfor
   endfor
endfunction
