def find_item_by_name_in_collection(name, collection)
  i=0
  while i < collection.length do
    if collection[i][:item] == name
      return collection[i]
    else
      nil
    end
    i += 1
  end
end

def consolidate_cart(cart)
  collection_item = []
  i = 0
  while i < cart.length
    new_item = find_item_by_name_in_collection(cart[i][:item], collection_item)
    if new_item != nil
      new_item[:count] += 1
    else
      #new_item[:count] = 1
      new_item = cart[i]
      new_item[:count] = 1
      #  new_item = {
      #    item: cart[i][:item],
      #    price: cart[i][:price],
      #    clearance: cart[i][:clearance],
      #    count: 1
      #  }
       collection_item << new_item
    end
    i += 1
  end
  collection_item
end

# while y < new_cart.length
#   if new_cart[i][:item] == coupons[y][:item]
#     if new_cart[i][:count] >= coupons[y][:num]
#       new_cart[i][:count] - coupons[y][:num]
#       new_cart_with_coupons << new_cart[i]
#       new_cart_with_coupons[i + 1] = new_cart[i]
#       new_cart_with_coupons[i + 1][:item] = new_cart[i][:item] + " W/COUPON"
#       new_cart_with_coupons[i + 1][:num] = coupons[y][:num]
#     end
#   end

def apply_coupons(cart, coupons)
  new_cart_with_coupons = []
  i = 0
  while i < coupons.length
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
    new_coupon_name = "#{coupons[i][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(new_coupon_name, cart)
    if cart_item && cart_item[:count] >= coupons[i][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[i][:num]
        cart_item[:count] -= coupons[i][:num]
      else
        cart_item_with_coupon = {
          :item => new_coupon_name,
          :price => coupons[i][:cost] / coupons[i][:num],
          :count => coupons[i][:num],
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[i][:num]
      end
    end
    i +=1
  end
  cart
end

def apply_clearance(cart)
  new_cart_with_clearance = []
  i = 0
  while i < cart.length
    if cart[i][:clearance] == true
      cart[i][:price] = cart[i][:price] - cart[i][:price]*0.20
      new_cart_with_clearance << cart[i]
    else
      new_cart_with_clearance << cart[i]
    end
    i += 1
  end
  new_cart_with_clearance
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupons_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(coupons_cart)
  total = 0
  i = 0
  while i < final_cart.length
    total += final_cart[i][:price] * final_cart[i][:count]
    i += 1
  end
  if total >= 100
    total = total - total*0.10
  end
  total
end
# Consult README for inputs and outputs
#
# This method should call
# * consolidate_cart
# * apply_coupons
# * apply_clearance
#
# BEFORE it begins the work of calculating the total (or else you might have
# some irritated customers
