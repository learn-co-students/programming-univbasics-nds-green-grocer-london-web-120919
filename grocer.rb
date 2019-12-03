def find_item_by_name_in_collection(name, collection)
  index = 0 
  while index < collection.length  
    if collection[index][:item] == name 
      return collection[index]
    end 
    index +=1 
  end
  nil
end



def consolidate_cart(cart)
  updated_cart = []
  index = 0 
  while index < cart.length do 
  new_item = find_item_by_name_in_collection(cart[index][:item], updated_cart)
  if new_item != nil 
    new_item[:count] +=1 
  else 
    new_item = {
      :item => cart[index][:item],
      :price => cart[index][:price],
      :clearance => cart[index][:clearance],
      :count => 1 
    }
    updated_cart << new_item
  end 
  index +=1 
end
updated_cart
end 


def apply_coupons(cart, coupons)
  index = 0 
  while index < coupons.length 
  shopping_item = find_item_by_name_in_collection(coupons[index][:item], cart)
  discounted_item = "#{coupons[index][:item]} W/COUPON"
  item_with_coupon = find_item_by_name_in_collection(discounted_item, cart)
  if shopping_item && shopping_item[:count] >= coupons[index][:num]
    if item_with_coupon
      item_with_coupon[:count] += coupons[index][:num]
      shopping_item[:count] -= coupons[index][:num]
    else 
      item_with_coupon = { 
        :item => discounted_item,
        :price => coupons[index][:cost] / coupons[index][:num],
        :count => coupons[index][:num],
        :clearance => shopping_item[:clearance]
      }
      cart << item_with_coupon
      shopping_item[:count] -= coupons[index][:num]
    end
  end
  index += 1 
end 
cart
end

def apply_clearance(cart)
  index = 0 
  while index < cart.length do 
    if cart[index][:clearance] 
    cart[index][:price] = (cart[index][:price] * 0.8).round(2)
    end 
    index +=1 
  end 
  cart 
end


def checkout(cart, coupons)
consolidated_cart = consolidate_cart(cart)
couponed_cart = apply_coupons(consolidated_cart, coupons)
final_cart = apply_clearance(couponed_cart)

total = 0 
counter = 0 

while counter < final_cart.length 
  total += final_cart[counter][:price] * final_cart[counter][:count]
  counter += 1
 end 
 
 if total > 100 
   total -= (total * 0.10)
 end 
 total 
end	
