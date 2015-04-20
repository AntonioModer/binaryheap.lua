
local bh = require('binaryheap')

local data = {
  { value = 98, payload = "pos08" }, -- 1
  { value = 28, payload = "pos05" }, -- 2
  { value = 36, payload = "pos06" }, -- 3
  { value = 48, payload = "pos09" }, -- 4
  { value = 68, payload = "pos10" }, -- 5
  { value = 58, payload = "pos13" }, -- 6
  { value = 80, payload = "pos15" }, -- 7
  { value = 46, payload = "pos04" }, -- 8
  { value = 19, payload = "pos03" }, -- 9
  { value = 66, payload = "pos11" }, -- 10
  { value = 22, payload = "pos02" }, -- 11
  { value = 60, payload = "pos12" }, -- 12
  { value = 15, payload = "pos01" }, -- 13
  { value = 83, payload = "pos14" }, -- 14 
  { value = 59, payload = "pos07" }, -- 15
}

local sort = function(t)
  table.sort(t, function(a,b) return (a.value < b.value) end)
  return t
end

local function newheap()
  -- create a heap with data
  local heap = bh.minUnique()
  for _, node in ipairs(data) do
    heap:insert(node.value,node.payload)
  end
  
  -- create a sorted list with data, sorted by 'value'
  local sorted = {}
  for k,v in pairs(data) do sorted[k] = v end
  sort(sorted)
  
  -- create a reverse list of the sorted table; returns sorted-index, based on 'value'
  local sreverse = {}
  for i,v in ipairs(sorted) do sreverse[v.value] = i end
    
  return heap, sorted, sreverse
end

local function testheap(heap, sorted)
  while sorted[1] do    
    local payload1, value1 = heap:pop()
    local payload2, value2 = sorted[1].payload, sorted[1].value
    table.remove(sorted, 1)
    assert.are.equal(payload1, payload2)
    assert.are.equal(value1, value2)
  end
end


describe("Testing MaxUnique heap", function()

  it("tests order of insertion", function()
    local h = newheap()
    assert.are.equal(h.payload[1], data[13].payload)
    assert.are.equal(h.payload[2], data[11].payload)
    assert.are.equal(h.payload[3], data[9].payload)
    assert.are.equal(h.payload[4], data[8].payload)
    assert.are.equal(h.payload[5], data[2].payload)
    assert.are.equal(h.payload[6], data[3].payload)
    assert.are.equal(h.payload[7], data[15].payload)
    assert.are.equal(h.payload[8], data[1].payload)
    assert.are.equal(h.payload[9], data[4].payload)
    assert.are.equal(h.payload[10], data[5].payload)
    assert.are.equal(h.payload[11], data[10].payload)
    assert.are.equal(h.payload[12], data[12].payload)
    assert.are.equal(h.payload[13], data[6].payload)
    assert.are.equal(h.payload[14], data[14].payload)
    assert.are.equal(h.payload[15], data[7].payload)
    
  end)

  it("Tests order of popping", function()
    testheap(newheap())
  end)
  
  it("Tests peek()", function()
    local heap, sorted, sreverse = newheap()
    local value, payload = heap:peek()
    -- correct values?
    assert.are.equal(value, sorted[1].value)
    assert.are.equal(payload, sorted[1].payload)
    -- are they still on the heap?
    assert.are.equal(value, heap.value[1])
    assert.are.equal(payload, heap.payload[1])
  end)

  describe("Testing removing elements", function()
      
    it("Tests removing a middle item", function()
      local heap, sorted, sreverse = newheap()
      local idx = 4
      local value = sorted[idx].value
      local payload = sorted[idx].payload
      local pl, v = heap:remove(payload)
      -- did we get the right ones?
      assert.are.equal(value, v)
      assert.are.equal(payload, pl)
      assert.is.Nil(heap[payload])
      -- remove from test data and compare
      table.remove(sorted, idx)
      testheap(heap, sorted)
    end)
    
    it("Tests removing the last item (of the array)", function()
      local heap, sorted, sreverse = newheap()
      local idx = #heap.value
      local value = sorted[idx].value
      local payload = sorted[idx].payload
      local pl, v = heap:remove(payload)
      -- did we get the right ones?
      assert.are.equal(value, v)
      assert.are.equal(payload, pl)
      assert.is.Nil(heap.reverse[payload])
      -- remove from test data and compare
      table.remove(sorted, idx)
      testheap(heap, sorted)
    end)
  
  end)
  
  describe("Testing inserting elements", function()
      
    it("Tests inserting a top item", function()
      local heap, sorted, sreverse = newheap()
      local nvalue = sorted[1].value - 10
      local npayload = {}
      table.insert(sorted, 1, {})
      sorted[1].value = nvalue
      sorted[1].payload = npayload
      heap:insert(nvalue, npayload)
      testheap(heap, sorted)
    end)
    
    it("Tests inserting a middle item", function()
      local heap, sorted, sreverse = newheap()
      local nvalue = 57
      local npayload = {}
      table.insert(sorted, { value = nvalue, payload = npayload })
      sort(sorted)
      heap:insert(nvalue, npayload)
      testheap(heap, sorted)
    end)
    
    it("Tests inserting a last item", function()
      local heap, sorted, sreverse = newheap()
      local nvalue = sorted[#sorted].value + 10
      local npayload = {}
      table.insert(sorted, {})
      sorted[#sorted].value = nvalue
      sorted[#sorted].payload = npayload
      heap:insert(nvalue, npayload)
      testheap(heap, sorted)
    end)
  
  end)
    
  describe("Testing updating elements", function()
      
    it("Tests updating a top item", function()
      local heap, sorted, sreverse = newheap()
      local idx = 1
      local payload = sorted[idx].payload
      local nvalue = sorted[#sorted].value + 1 -- move to end with new value
      sorted[idx].value = nvalue
      sort(sorted)
      heap:update(payload, nvalue)
      testheap(heap, sorted)
    end)
    
    it("Tests updating a middle item", function()
      local heap, sorted, sreverse = newheap()
      local idx = 4
      local payload = sorted[idx].payload
      local nvalue = sorted[idx].value * 2 
      sorted[idx].value = nvalue
      sort(sorted)
      heap:update(payload, nvalue)
      testheap(heap, sorted)
    end)
    
    it("Tests updating a last item", function()
      local heap, sorted, sreverse = newheap()
      local idx = #sorted
      local payload = sorted[idx].payload
      local nvalue = sorted[1].value - 1 -- move to top with new value
      sorted[idx].value = nvalue
      sort(sorted)
      heap:update(payload, nvalue)
      testheap(heap, sorted)
    end)
  
  end)

end)