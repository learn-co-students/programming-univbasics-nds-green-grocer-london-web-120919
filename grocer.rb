require 'pry'
require 'pp'


def find_item_by_name_in_collection(name, collection)
  items_index = 0
  while items_index < collection.length
      if collection[items_index][:item] == name
        return collection[items_index]
      end
    items_index += 1
  end
end

def consolidate_cart(cart)
  new_cart = []
  counter = 0
  while counter < cart.length do
    new_cart_item = find_item_by_name_in_collection(cart[counter][:item], new_cart)
    
    if new_cart_item
      new_cart_item[:count] += 1
    else
      new_cart_item = cart[counter]
      new_cart_item[:count] = 1
      
      new_cart << new_cart_item
    end
    
    counter += 1
  end
  
  new_cart
end

  
  


def apply_coupons(cart, coupons)  
  coupon_index = 0
  while coupon_index < coupons.length do
    coupon = coupons[coupon_index]
    cart_item = find_item_by_name_in_collection(coupon[:item], cart)
    
    if cart_item && cart_item[:count] >= coupon[:num]
      new_cart_item = {
        :item => cart_item[:item] + " W/COUPON",
        :price => coupon[:cost] / coupon[:num],
        :count => coupon[:num],
        :clearance => cart_item[:clearance]
      }
      
      cart << new_cart_item
      cart_item[:count] -= coupon[:num]
    end
    
    coupon_index += 1
  end
  cart
end

def apply_clearance(cart)
  cart_reduced = []
  cart_index = 0
  while cart_index < cart.length do
     cart_item = cart[cart_index]
     if cart_item[:clearance]
       cart_item[:price] *= 0.8
     end
     cart_reduced << cart_item
    cart_index += 1
  end
  cart_reduced
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
  
  concart = consolidate_cart(cart)
  coupon_cart = apply_coupons(concart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  
  cart_total = 0
  clearance_index = 0
  while clearance_index < clearance_cart.length do
    cart_total += clearance_cart[clearance_index][:price] * clearance_cart[clearance_index][:count]
    clearance_index += 1
  end
  if cart_total > 100
    cart_total *= 0.9
  end
  
  return cart_total.round(2)
  
  
end
