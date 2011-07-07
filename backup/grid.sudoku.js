//Only works for jQuery
$ = jQuery;
$.fn.initGrid = function(){
  //create grid here
  var thisObj = $(this);
  var convas = $('#sudokutbl_convas', thisObj);
  convas.empty();
  convas.append('\
          <table id="sudokutbl">\
            <tr>\
              <td id="cell11"></td>\
              <td id="cell12"></td>\
              <td id="cell13"></td>\
              <td id="cell14"></td>\
              <td id="cell15"></td>\
              <td id="cell16"></td>\
              <td id="cell17"></td>\
              <td id="cell18"></td>\
              <td id="cell19"></td>\
            </tr><tr>\
              <td id="cell21"></td>\
              <td id="cell22"></td>\
              <td id="cell23"></td>\
              <td id="cell24"></td>\
              <td id="cell25"></td>\
              <td id="cell26"></td>\
              <td id="cell27"></td>\
              <td id="cell28"></td>\
              <td id="cell29"></td>\
            </tr><tr>\
              <td id="cell31"></td>\
              <td id="cell32"></td>\
              <td id="cell33"></td>\
              <td id="cell34"></td>\
              <td id="cell35"></td>\
              <td id="cell36"></td>\
              <td id="cell37"></td>\
              <td id="cell38"></td>\
              <td id="cell39"></td>\
            </tr><tr>\
              <td id="cell41"></td>\
              <td id="cell42"></td>\
              <td id="cell43"></td>\
              <td id="cell44"></td>\
              <td id="cell45"></td>\
              <td id="cell46"></td>\
              <td id="cell47"></td>\
              <td id="cell48"></td>\
              <td id="cell49"></td>\
            </tr><tr>\
              <td id="cell51"></td>\
              <td id="cell52"></td>\
              <td id="cell53"></td>\
              <td id="cell54"></td>\
              <td id="cell55"></td>\
              <td id="cell56"></td>\
              <td id="cell57"></td>\
              <td id="cell58"></td>\
              <td id="cell59"></td>\
            </tr><tr>\
              <td id="cell61"></td>\
              <td id="cell62"></td>\
              <td id="cell63"></td>\
              <td id="cell64"></td>\
              <td id="cell65"></td>\
              <td id="cell66"></td>\
              <td id="cell67"></td>\
              <td id="cell68"></td>\
              <td id="cell69"></td>\
            </tr><tr>\
              <td id="cell71"></td>\
              <td id="cell72"></td>\
              <td id="cell73"></td>\
              <td id="cell74"></td>\
              <td id="cell75"></td>\
              <td id="cell76"></td>\
              <td id="cell77"></td>\
              <td id="cell78"></td>\
              <td id="cell79"></td>\
            </tr><tr>\
              <td id="cell81"></td>\
              <td id="cell82"></td>\
              <td id="cell83"></td>\
              <td id="cell84"></td>\
              <td id="cell85"></td>\
              <td id="cell86"></td>\
              <td id="cell87"></td>\
              <td id="cell88"></td>\
              <td id="cell89"></td>\
            </tr><tr>\
              <td id="cell91"></td>\
              <td id="cell92"></td>\
              <td id="cell93"></td>\
              <td id="cell94"></td>\
              <td id="cell95"></td>\
              <td id="cell96"></td>\
              <td id="cell97"></td>\
              <td id="cell98"></td>\
              <td id="cell99"></td>\
            </tr>\
          </table>\
          <h6 id="level_of_sudo"></h6>\
          <h5><a rel="classic" class="styleswitch" style="cursor:pointer;">Classic</a> | <a rel="green_style" class="styleswitch" style="cursor:pointer;">Green</a> </h5> \
    ');
};