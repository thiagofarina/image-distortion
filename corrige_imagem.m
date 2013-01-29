#
# Exemplo de como rodar o programa:
#
# source("corrige_imagem.m");
# imagemTorta = imread("imagem_torta.jpg");
# imagemNormal = corrigeImagem(imagemTorta);
# imwrite(imagemNormal, "imagem_normal.jpg");
#

function imageSaida = corrigeImagem(imagemEntrada)
  # Cria a matriz (u,v) usando os pontos da imagem original.
  MatOrig = [ 71, 184;  117, 146; 44, 264;
              435, 446; 550, 510; 620, 202 ];

  # Cria a matriz (r, s) usando os pontos da imagem distorcida.
  MatDist = [ 56, 295;  83, 264;  45, 348;
              324, 459; 426, 508; 568, 245 ];

  # Inicializa a matriz A.
  A = [ MatOrig(1, 1), MatOrig(1, 2), 1, 0, 0, 0, - MatOrig(1, 1) * MatDist(1, 1), - MatOrig(1, 2) * MatDist(1, 1);
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

  # Cria a matriz L a partiz dos pontos da MatDist.
  L = [ MatDist(1, 1), MatDist(1, 2),
        MatDist(2, 1), MatDist(2, 2),
        MatDist(3, 1), MatDist(3, 2),
        MatDist(4, 1), MatDist(4, 2),
        MatDist(5, 1), MatDist(5, 2),
        MatDist(6, 1), MatDist(6, 2) ];

  # Calculo pelo método dos Mínimos Quadrados.
  # x = (At * A) -¹ * At * L

  matrizAux = A' * A;
  X = inv(matrizAux) * A' * L;

  T(1, 1) = X(1, 1);
  T(1, 2) = X(2, 1);
  T(1, 3) = X(3, 1);
  T(2, 1) = X(4, 1);
  T(2, 2) = X(5, 1);
  T(2, 3) = X(6, 1);
  T(3, 1) = X(7, 1);
  T(3, 2) = X(8, 1);
  T(3, 3) = 1;

  # Lista variáveis definidas correspondente aos padrões dados.
  whos
  size(imagemEntrada, 1)
  size(imagemEntrada, 2)

  # Calcula os novos pontos na |imagemSaida|.
  for linha = 1: size(imagemEntrada, 1)
    for coluna = 1: size(imagemEntrada, 2)
       aux = T * [linha; coluna; 1];
       result = [aux(1, 1, 1) / aux(3, 1, 1);
       aux(2, 1, 1) / aux(3, 1, 1);
       aux(3, 1, 1) / aux(3, 1, 1)];
       # Retorna o inteiro próximo de result(1, 1).
       w = round(result(1, 1));
       # Retorna o inteiro próximo de result(2, 1).
       z  = round(result(2, 1));
       if ((w >= 1) && (z >= 1) && (w <= size(imagemEntrada, 1)) && (z <= size(imagemEntrada, 2)))
         imagemSaida(linha, coluna, 1) = imagemEntrada(w, z, 1);
       endif
     endfor
   endfor
endfunction;
