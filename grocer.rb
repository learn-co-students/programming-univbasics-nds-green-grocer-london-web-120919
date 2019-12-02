require 'pry'

def find_item_by_name_in_collection(name, collection)
  i = 0
  while i < collection.length do
    return collection[i] if collection[i][:item] == name
    i +=1
  end
end

def consolidate_cart(cart)
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  unique_cart = cart.uniq

  index = 0
    while index < unique_cart.length do
      this_item_name = unique_cart[index][:item]

      cart_index = 0
      item_count = 0
        while cart_index < cart.length do
          item_count +=1 if cart[cart_index][:item] == this_item_name
          cart_index += 1
        end

      unique_cart[index][:count] = item_count
      index += 1
    end
  unique_cart
end


# def apply_coupons(cart, coupons)
#   # binding.pry
#   # REMEMBER: This method **should** update cart
#   coupons_with_names = {}
#   coupon_i = 0
#     while coupon_i < coupons.length do
#       name = coupons[coupon_i][:item]
#       coupons_with_names[name] = coupons[coupon_i]
#       coupon_i += 1
#     end
#
#   updated_cart = cart
#   i = 0
#     while i < updated_cart.length do
#       if updated_cart[i][:clearance]
#         item_on_sale = updated_cart[i][:item]
#         item_frequency = updated_cart[i][:count]
#         coupon_frequency = coupons_with_names[item_on_sale][:num]
#         enough_items = item_frequency >= coupon_frequency
#         non_discounted_items = item_frequency % coupon_frequency
#
#         items_with_discount_frequency = if !enough_items
#           0
#           elsif enough_items && non_discounted_items == 0
#             item_frequency / coupon_frequency
#           else
#             (item_frequency - non_discounted_items) / item_frequency
#           end
#
#         item_with_discount_name = "#{item_on_sale} W/COUPON"
#         item_with_discount_price = coupons_with_names[item_on_sale][:num] / coupons_with_names[item_on_sale][:cost]
#
#         item_with_discount_hash = {:item => item_with_discount_name, :price => item_with_discount_price, :clearance => true, :count => items_with_discount_frequency}
#         updated_cart << item_with_discount_hash if items_with_discount_frequency != 0
#
#         updated_cart[i][:count] = non_discounted_items
#       end
#       i+=1
#     end
#   updated_cart
# end
def apply_coupons(cart, coupons)
  counter = 0
  while counter < coupons.length do
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    if cart_item && cart_item[:count] >= coupons[counter][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[counter][:num]
        cart_item[:count] -= coupons[counter][:num]
      else
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupons[counter][:cost] / coupons[counter][:num],
          :clearance => cart_item[:clearance],
          :count => coupons[counter][:num]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[counter][:num]
      end
    end
    counter += 1
  end
  cart
end


def apply_clearance(cart)
 counter = 0
 while counter < cart.length do
   if cart[counter][:clearance]
     cart[counter][:price] = (cart[counter][:price] * 0.8).round(2)
   end
   counter += 1
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
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  counter = 0
  total = 0
  while counter < cart.length do
    items_cost = cart[counter][:price] * cart[counter][:count]
    total += items_cost
    counter += 1
  end
  if total > 100
    total -= (total * 0.1)
  end
  total
end
