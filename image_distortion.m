# Exemplo:
#
#  source("image_distortion.m");
#  imagemOriginal = imread("imagem-distorcida.jpg");
#  imagemFinal = image_distortion(imagemOriginal, 2, 2);
#  imwrite(imagemFinal, "imagem-normal.jpg");
#
function Iout = nneig(Iin, sx, sy)
  Iout = zeros(round(size(Iin, 1) * sx), round(size(Iin, 2) * sy));
  TsInv = zeros(3, 3);
  TsInv(1, 1) = 1 / sx;
  TsInv(2, 2) = 1 / sy;
  TsInv(3, 3) = 1;

  for i = 1 : size(Iout, 1)
    for j = 1 : size(Iout, 2)
      VCoord = round(TsInv * [i - 1; j - 1; 1] + [1; 1; 0];
      if VCoord(1, 1) <= size(Iin, 1) && VCoord(2, 1) <= size(Iin, 2)
        Iout(i, j) = Iin(VCoord(1, 1), VCoord(2, 1));
      else
        % i, j, size(Iout)
      endif
    endfor
  endfor
endfunction
