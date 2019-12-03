def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  i = 0
  item_hash = {}
  while i < collection.size
    if collection[i][:item] == name
      return collection[i]
    end
    i += 1
  end
  return nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  i = 0
  cart_array = []
  while i < cart.length
    if !find_item_by_name_in_collection(cart[i][:item], cart_array)
      cart_array.push(cart[i])
      cart_array[-1][:count] = 1
    else
      cart_item_i = 0
      while cart_item_i < cart_array.length
        if cart_array[cart_item_i][:item] == cart[i][:item]
          cart_array[cart_item_i][:count] += 1
        end
      cart_item_i += 1
      end
    end
    i += 1
  end
  cart_array
end

def apply_coupons(cart, coupons)
   require 'pp'
  # pp cart
  # print 'break'
  # pp coupons
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  i = 0
  while i < coupons.length
      cart_item_i = 0
      while cart_item_i < cart.length
      item_coupon_hash = {}
        if cart[cart_item_i][:item] == coupons[i][:item] && cart[cart_item_i][:count] >= coupons[i][:num]
          cart[cart_item_i][:count] -= coupons[i][:num]
          item_coupon_hash[:item] = coupons[i][:item] + ' W/COUPON'
          item_coupon_hash[:price] = coupons[i][:cost] / coupons[i][:num]
          item_coupon_hash[:clearance] = cart[cart_item_i][:clearance]
          item_coupon_hash[:count] = coupons[i][:num]
          cart.push(item_coupon_hash)
          
         # if cart[cart_item_i][:item] == coupons[i][:item] && cart[cart_item_i][:count] <= 0
         #   cart.delete_at(cart_item_i)
         # end
        end
      cart_item_i += 1
      end
    i += 1
  end
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  i = 0
  while i < cart.length
    if cart[i][:clearance]
      cart[i][:price] = (cart[i][:price] * 0.8).round(2)
    end
    i += 1
  end
  cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  
  i = 0
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  
  while i < final_cart.length
    total += final_cart[i][:price] * final_cart[i][:count]
    i += 1
  end
  if total > 100
    total *= 0.9
  end
  total
end
