

#define TEST__RT_INDEX			65536
#define TEST__RT_HEIGHT			3




//---------------------------------------------------------------------------------------------//

int f_0101(void)
{
#define TEST__RADIX_TREE_INDIRECT_PTR	1
	char	flag;

	flag = 1;
	printf("(1): %x\n", flag);
	printf("~(1): %x\n", ~flag);
	printf("!(1): %x\n", !flag);

	flag = 0;
	printf("(0): %x\n", flag);
	printf("~(0): %x\n", ~flag);
	printf("!(0): %x\n", !flag);

	return 0;
}

//---------------------------------------------------------------------------------------------//

#define TEST__BITS_PER_LONG		64
#define TEST__RT_MAX_TAGS		3
#define TEST__RT_MAP_SHIFT		6
#define TEST__RT_MAP_SIZE		(1UL << TEST__RT_MAP_SHIFT)		// 64
#define TEST__RT_TAG_LONGS		((TEST__RT_MAP_SIZE + TEST__BITS_PER_LONG - 1) / (TEST__BITS_PER_LONG))	// 1
#define TEST__RT_MAP_MASK		(TEST__RT_MAP_SIZE - 1)	// 63

struct rt_node {
	unsigned int		height;
	unsigned int		count;
	void *				slots[TEST__RT_MAP_SIZE];
	unsigned long		tags[TEST__RT_MAX_TAGS][TEST__RT_TAG_LONGS];
};

struct rt_root {
	unsigned int		height;
	struct rt_node *	rnode;
};




#if 1 /* KERNEL */

static inline int rcu_read_lock_held(void)
{
#if 0
	if (!debug_lockdep_rcu_enabled())
		return 1;
	return lock_is_held(&rcu_lock_map);
#else
	return 0;
#endif
}

#define __rcu_dereference_check(p, c, space) \
	({ \
		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
//		rcu_lockdep_assert(c); \
		rcu_dereference_sparse(p, space); \
		smp_read_barrier_depends(); \
		((typeof(*p) __force __kernel *)(_________p1)); \
	})


#define rcu_dereference_check(p, c) \
	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)

#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/

#endif /* KERNEL */




int f_0102_lookup(int index, int height)
{

	int		shift;
	int		slotn;	// slot number
//	char	slots[TEST__RT_MAP_SIZE];

	shift = (height - 1) * TEST__RT_MAP_SHIFT;
	slotn = ((index >> shift) & TEST__RT_MAP_MASK);

	return slotn;
}



int f_0102(void)
{
	int index = TEST__RT_INDEX;
	int height = TEST__RT_HEIGHT;
	int slotn;

	slotn = f_0102_lookup(index, height);
	printf("f_0102:: slotn(index=%d, height=%d): %d\n", index, height, slotn);
	return slotn;
}




//---------------------------------------------------------------------------------------------//

struct sb {
	int counter;
	int height;
};

struct sa {
	int a_1;
	int a_2;
	
	union {
		unsigned long val;
		void * vp;
		char * cp;
		struct sb * sbp;
	};
};


int f_0103(void)
{
	/* union, struct test */
	struct sa aero;
	struct sb blur;

	blur.counter = 33;
	blur.height = 55;

	aero.a_1 = blur.counter;
	aero.a_2 = blur.height;
	aero.sbp = &blur;
	
	printf("blur.counter: %d\n", blur.counter);
	printf("blur.height: %d\n", blur.height);
	printf("aero.a_1: %d\n", aero.a_1);
	printf("aero.a_2: %d\n", aero.a_2);
	printf("aero.sbp (%%p): %p\n", aero.sbp);
	printf("aero.val (%%lx): %lx\n", aero.val);
	printf("aero.vp (%%p): %p\n", aero.vp);
	printf("(struct sb *)(aero.vp)->counter: %d\n", ((struct sb *)(aero.vp))->counter);
	printf("(struct sb *)(aero.vp)->height: %d\n", ((struct sb *)(aero.vp))->height);

	return 0;
}
