class Y
  include StatusObject

  add_status 0, :not_ready
  add_status 1, :ready, text: 'r_e_a_d_y', display: 'REaDY'
  add_status 2, :done, text: 'd_o_n_e____', display: '<-done->'
end

class Z
  VALUES = {
    cat: 3,
    dog: 4,
    bird: 5
  }

  include StatusObject

  add_status 0, :not_ready
  add_status 1, :ready, text: 'r_e_a_d_y', display: 'REaDY'
  add_status 2, :done, text: 'd_o_n_e____', display: '<-done->'
end
