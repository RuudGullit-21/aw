
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("мсвМаршрутныеЛистыИЗаказы") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Константы.уатЕдиницаИзмеренияВеса.Получить() = Перечисления.уатЕдиницыИзмеренияВеса.Килограмм Тогда
		КоэфВеса = 1000;
	Иначе 
		КоэфВеса = 1;
	КонецЕсли;
	ПредставлениеЕдиницыИзмеренияВеса = уатОбщегоНазначенияПовтИсп.ПолучитьПредставлениеОсновнойЕдиницыИзмеренияВеса();
	Если ЗначениеЗаполнено(ПредставлениеЕдиницыИзмеренияВеса) Тогда
		Элементы.СозданныеДокументыВес.Заголовок = НСтр("en='Weight, ';ru='Вес, '") + ПредставлениеЕдиницыИзмеренияВеса;
		Элементы.НовыеДокументыВес.Заголовок     = НСтр("en='Weight, ';ru='Вес, '") + ПредставлениеЕдиницыИзмеренияВеса;
	КонецЕсли;
	
	ПредставлениеЕдиницыИзмеренияОбъема = уатОбщегоНазначенияПовтИсп.ПолучитьПредставлениеОсновнойЕдиницыИзмеренияОбъема();
	Если ЗначениеЗаполнено(ПредставлениеЕдиницыИзмеренияОбъема) Тогда
		Элементы.НовыеДокументыОбъем.Заголовок        = НСтр("en='Volume, ';ru='Объем, '") + ПредставлениеЕдиницыИзмеренияОбъема;
	КонецЕсли;

	Если Параметры.Свойство("флВыборЭПД") Тогда
		флВыборЭПД = Истина;
	ИначеЕсли Параметры.Свойство("флВыборЗаказа") Тогда
		флагВыборЗаказа = Параметры.флВыборЗаказа;
		флагВыборМаршрутногоЛиста = Не флагВыборЗаказа;
	ИначеЕсли Параметры.мсвМаршрутныеЛистыИЗаказы.Количество() > 1 Тогда
		флагВыборЗаказа = (Параметры.мсвМаршрутныеЛистыИЗаказы[0].Значение.Заказ <> Параметры.мсвМаршрутныеЛистыИЗаказы[1].Значение.Заказ);
		флагВыборМаршрутногоЛиста = Не флагВыборЗаказа;
	Иначе
		флагВыборЗаказа = Ложь;
		флагВыборМаршрутногоЛиста = Ложь;
	КонецЕсли;
	
	// Заполнение документов в таблицах
	Для Каждого ТекЛистИЗаказ Из Параметры.мсвМаршрутныеЛистыИЗаказы Цикл
		
		Если флВыборЭПД Тогда 
			Строка = НовыеДокументы.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, ТекЛистИЗаказ);
			Строка.флагВыбора = Истина;
		ИначеЕсли ТекЛистИЗаказ.Значение.ТТД.Пустая() Тогда
			Строка = НовыеДокументы.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, ТекЛистИЗаказ.Значение);
			Строка.флагВыбора = Истина;
		Иначе
			Строка = СозданныеДокументы.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, ТекЛистИЗаказ.Значение);
		КонецЕсли;
		
		Если флВыборЭПД Тогда
			Если ТипЗнч(Строка.МаршрутныйЛист) = Тип("ДокументСсылка.уатМаршрутныйЛист") Тогда
				Строка.ТС = Строка.МаршрутныйЛист.ТС;
			ИначеЕсли ТипЗнч(Строка.МаршрутныйЛист) = Тип("ДокументСсылка.уатПутевойЛист") Тогда
				Строка.ТС = Строка.МаршрутныйЛист.ТранспортноеСредство;
			Иначе
				Строка.ТС = Строка.МаршрутныйЛист.ТС;
			КонецЕсли;  
			Если ТипЗнч(Строка.МаршрутныйЛист) = Тип("ДокументСсылка.уатЗаказПеревозчику_уэ") Тогда
				Строка.Водитель = Строка.МаршрутныйЛист.Водитель;
			Иначе
				Строка.Водитель = Строка.МаршрутныйЛист.Водитель1;
			КонецЕсли;
			Строка.Перевозчик = Строка.МаршрутныйЛист.Контрагент;
			Если ТекЛистИЗаказ.Свойство("Груз") Тогда
				флВыборFTLЭПД = Истина; 
			КонецЕсли;


		ИначеЕсли флагВыборЗаказа Тогда
			Строка.Контрагент = Строка.Заказ.Контрагент;
			Строка.Договор = Строка.Заказ.ДоговорКонтрагента;
		Иначе
			Строка.Перевозчик = Строка.МаршрутныйЛист.Контрагент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если флВыборЭПД Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение веса, объема, количества и количества мест для пар Заказ-Маршрутный лист, для которых еще нет ТТД
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыМаршрутныеЛисты.Заказ КАК Заказ,
	|	ЗаказыМаршрутныеЛисты.МаршрутныйЛист КАК МаршрутныйЛист
	|ПОМЕСТИТЬ втЗаказыМаршрутныеЛисты
	|ИЗ
	|	&ЗаказыМаршрутныеЛисты КАК ЗаказыМаршрутныеЛисты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втЗаказыМаршрутныеЛисты.Заказ КАК Заказ,
	|	втЗаказыМаршрутныеЛисты.МаршрутныйЛист КАК МаршрутныйЛист,
	|	уатЗаказГрузоотправителя.ДетализацияЗакрытия КАК ДетализацияЗакрытия
	|ПОМЕСТИТЬ втЗаказыСДетализацией
	|ИЗ
	|	втЗаказыМаршрутныеЛисты КАК втЗаказыМаршрутныеЛисты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.уатЗаказГрузоотправителя КАК уатЗаказГрузоотправителя
	|		ПО втЗаказыМаршрутныеЛисты.Заказ = уатЗаказГрузоотправителя.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втЗаказыСДетализацией.Заказ КАК Заказ,
	|	втЗаказыСДетализацией.МаршрутныйЛист КАК МаршрутныйЛист,
	|	втЗаказыСДетализацией.ДетализацияЗакрытия КАК ДетализацияЗакрытия,
	|	СУММА(ЕСТЬNULL(уатГрузыКПеревозке_уэ.Количество, 0)) КАК КоличествоПоРегистру,
	|	уатГрузыКПеревозке_уэ.ГрузовоеМесто КАК ГрузовоеМесто,
	|	уатГрузыКПеревозке_уэ.Номенклатура КАК Номенклатура,
	|	уатГрузыКПеревозке_уэ.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ПОМЕСТИТЬ втЗаказыСКоличествомПоРегистру
	|ИЗ
	|	втЗаказыСДетализацией КАК втЗаказыСДетализацией
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатГрузыКПеревозке_уэ КАК уатГрузыКПеревозке_уэ
	|		ПО втЗаказыСДетализацией.Заказ = уатГрузыКПеревозке_уэ.ЗаказГрузоотправителя
	|			И втЗаказыСДетализацией.МаршрутныйЛист = уатГрузыКПеревозке_уэ.Регистратор
	|
	|СГРУППИРОВАТЬ ПО
	|	втЗаказыСДетализацией.Заказ,
	|	втЗаказыСДетализацией.МаршрутныйЛист,
	|	втЗаказыСДетализацией.ДетализацияЗакрытия,
	|	уатГрузыКПеревозке_уэ.ГрузовоеМесто,
	|	уатГрузыКПеревозке_уэ.Номенклатура,
	|	уатГрузыКПеревозке_уэ.ЕдиницаИзмерения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втЗаказыСКоличествомПоРегистру.Заказ КАК Заказ,
	|	втЗаказыСКоличествомПоРегистру.МаршрутныйЛист КАК МаршрутныйЛист,
	|	втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия КАК ДетализацияЗакрытия,
	|	СУММА(втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру) КАК Количество,
	|	СУММА(ВЫБОР
	|			КОГДА уатЗаказГрузоотправителяТовары.Количество = 0
	|				ТОГДА уатЗаказГрузоотправителяТовары.КоличествоМест
	|			ИНАЧЕ уатЗаказГрузоотправителяТовары.КоличествоМест * втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру / уатЗаказГрузоотправителяТовары.Количество
	|		КОНЕЦ) КАК КоличествоМест,
	|	СУММА(втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру) КАК КоличествоТоваров,
	|	СУММА(0) КАК КоличествоГрузовыхМест,
	|	СУММА(ВЫБОР
	|			КОГДА уатЗаказГрузоотправителяТовары.Количество = 0
	|				ТОГДА уатЗаказГрузоотправителяТовары.ВесБрутто
	|			ИНАЧЕ уатЗаказГрузоотправителяТовары.ВесБрутто * втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру / уатЗаказГрузоотправителяТовары.Количество
	|		КОНЕЦ) КАК ВесБрутто,
	|	СУММА(ВЫБОР
	|			КОГДА уатЗаказГрузоотправителяТовары.Количество = 0
	|				ТОГДА уатЗаказГрузоотправителяТовары.Объем
	|			ИНАЧЕ уатЗаказГрузоотправителяТовары.Объем * втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру / уатЗаказГрузоотправителяТовары.Количество
	|		КОНЕЦ) КАК Объем
	|ИЗ
	|	втЗаказыСКоличествомПоРегистру КАК втЗаказыСКоличествомПоРегистру
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.уатЗаказГрузоотправителя.Товары КАК уатЗаказГрузоотправителяТовары
	|		ПО втЗаказыСКоличествомПоРегистру.Заказ = уатЗаказГрузоотправителяТовары.Ссылка
	|			И (втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия = ЗНАЧЕНИЕ(Перечисление.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам))
	|			И втЗаказыСКоличествомПоРегистру.Номенклатура = уатЗаказГрузоотправителяТовары.Номенклатура
	|			И втЗаказыСКоличествомПоРегистру.ЕдиницаИзмерения = уатЗаказГрузоотправителяТовары.ЕдиницаИзмерения
	|
	|СГРУППИРОВАТЬ ПО
	|	втЗаказыСКоличествомПоРегистру.Заказ,
	|	втЗаказыСКоличествомПоРегистру.МаршрутныйЛист,
	|	втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втЗаказыСКоличествомПоРегистру.Заказ,
	|	втЗаказыСКоличествомПоРегистру.МаршрутныйЛист,
	|	втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия,
	|	СУММА(втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру),
	|	СУММА(втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру),
	|	СУММА(0),
	|	СУММА(втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру),
	|	СУММА(ВЫБОР
	|			КОГДА уатЗаказГрузоотправителяГрузовойСостав.КоличествоМест = 0
	|				ТОГДА уатЗаказГрузоотправителяГрузовойСостав.ВесБрутто
	|			ИНАЧЕ уатЗаказГрузоотправителяГрузовойСостав.ВесБрутто * втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру / уатЗаказГрузоотправителяГрузовойСостав.КоличествоМест
	|		КОНЕЦ),
	|	СУММА(ВЫБОР
	|			КОГДА уатЗаказГрузоотправителяГрузовойСостав.КоличествоМест = 0
	|				ТОГДА уатЗаказГрузоотправителяГрузовойСостав.Объем
	|			ИНАЧЕ уатЗаказГрузоотправителяГрузовойСостав.Объем * втЗаказыСКоличествомПоРегистру.КоличествоПоРегистру / уатЗаказГрузоотправителяГрузовойСостав.КоличествоМест
	|		КОНЕЦ)
	|ИЗ
	|	втЗаказыСКоличествомПоРегистру КАК втЗаказыСКоличествомПоРегистру
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.уатЗаказГрузоотправителя.ГрузовойСостав КАК уатЗаказГрузоотправителяГрузовойСостав
	|		ПО втЗаказыСКоличествомПоРегистру.Заказ = уатЗаказГрузоотправителяГрузовойСостав.Ссылка
	|			И (втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия = ЗНАЧЕНИЕ(Перечисление.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам))
	|			И втЗаказыСКоличествомПоРегистру.ГрузовоеМесто = уатЗаказГрузоотправителяГрузовойСостав.ГрузовоеМесто
	|
	|СГРУППИРОВАТЬ ПО
	|	втЗаказыСКоличествомПоРегистру.Заказ,
	|	втЗаказыСКоличествомПоРегистру.МаршрутныйЛист,
	|	втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втЗаказыСКоличествомПоРегистру.Заказ,
	|	втЗаказыСКоличествомПоРегистру.МаршрутныйЛист,
	|	втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия,
	|	СУММА(1),
	|	СУММА(уатЗаказГрузоотправителя.КоличествоМест),
	|	СУММА(0),
	|	СУММА(0),
	|	СУММА(уатЗаказГрузоотправителя.ВесБрутто),
	|	СУММА(уатЗаказГрузоотправителя.Объем)
	|ИЗ
	|	втЗаказыСКоличествомПоРегистру КАК втЗаказыСКоличествомПоРегистру
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.уатЗаказГрузоотправителя КАК уатЗаказГрузоотправителя
	|		ПО втЗаказыСКоличествомПоРегистру.Заказ = уатЗаказГрузоотправителя.Ссылка
	|			И (втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия = ЗНАЧЕНИЕ(Перечисление.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам))
	|
	|СГРУППИРОВАТЬ ПО
	|	втЗаказыСКоличествомПоРегистру.Заказ,
	|	втЗаказыСКоличествомПоРегистру.МаршрутныйЛист,
	|	втЗаказыСКоличествомПоРегистру.ДетализацияЗакрытия";
	ТипыТочекМаршрутаПогрузка = Новый Массив;
	ТипыТочекМаршрутаПогрузка.Добавить(Перечисления.уатТипыТочекМаршрута.Погрузка);
	ТипыТочекМаршрутаПогрузка.Добавить(Перечисления.уатТипыТочекМаршрута.ДополнительнаяПогрузка);
	Запрос.УстановитьПараметр("ТипыТочекМаршрутаПогрузка", ТипыТочекМаршрутаПогрузка);
	Запрос.УстановитьПараметр("ЗаказыМаршрутныеЛисты", НовыеДокументы.Выгрузить(, "Заказ, МаршрутныйЛист"));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НайденныеСтроки = НовыеДокументы.НайтиСтроки(Новый Структура("Заказ, МаршрутныйЛист", Выборка.Заказ, Выборка.МаршрутныйЛист));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(НайденныеСтроки[0], Выборка, "КоличествоТоваров, КоличествоГрузовыхМест, Количество, КоличествоМест, ВесБрутто, Объем");
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение возможных новых ТТД для тех пар Заказ (FTL)-Маршрутный лист, для которых уже есть ТТД
	СписокЗаказов = Новый СписокЗначений;
	предЗаказ = Неопределено;
	Для Каждого ТекСтрока Из СозданныеДокументы Цикл
		Если ТекСтрока.FTL И ТекСтрока.Заказ <> предЗаказ Тогда
			предЗаказ = ТекСтрока.Заказ;
			СписокЗаказов.Добавить(ТекСтрока.Заказ);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокЗаказов.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = Документы.уатТТД.ГрузыFTLЗаказовНеВТТДТекстЗапроса();
		Запрос.УстановитьПараметр("ЗаказСсылка", СписокЗаказов);
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		РезультатЗапроса.Свернуть("ЗаказГрузоотправителя", "КоличествоТоваров, КоличествоГрузовыхМест, Количество, КоличествоМест, ВесБрутто, Объем");
		Для Каждого ТекСтрока Из РезультатЗапроса Цикл
			НайденныеСтроки = СозданныеДокументы.НайтиСтроки(Новый Структура("Заказ", ТекСтрока.ЗаказГрузоотправителя));
			Если НайденныеСтроки.Количество() > 0 Тогда
				НоваяСтрока = НовыеДокументы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденныеСтроки[0]);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока, "КоличествоТоваров, КоличествоГрузовыхМест, Количество, КоличествоМест, ВесБрутто, Объем");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Заполнение веса и кол-ва упаковок для уже созданных документов ТТД
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокТТД.ТТД КАК Ссылка
	|ПОМЕСТИТЬ втТТД
	|ИЗ
	|	&СписокТТД КАК СписокТТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	уатТТДГрузы.Ссылка КАК Ссылка,
	|	СУММА(ЕСТЬNULL(уатТТДГрузы.КоличествоМест, 0)) КАК КоличествоМест,
	|	СУММА(ЕСТЬNULL(уатТТДГрузы.КоличествоТонн * &КоэфВеса, 0)) КАК ВесБрутто,
	|	СУММА(ЕСТЬNULL(уатТТДГрузы.Количество, 0)) КАК Количество
	|ИЗ
	|	втТТД КАК втТТД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатТТД.Грузы КАК уатТТДГрузы
	|		ПО втТТД.Ссылка = уатТТДГрузы.Ссылка
	|ГДЕ
	|	уатТТДГрузы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	уатТТДГрузы.Ссылка";
	Запрос.УстановитьПараметр("СписокТТД", СозданныеДокументы.Выгрузить(,"ТТД"));
	Запрос.УстановитьПараметр("КоэфВеса", КоэфВеса);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НайденныеСтроки = СозданныеДокументы.НайтиСтроки(Новый Структура("ТТД", Выборка.Ссылка));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(НайденныеСтроки[0], Выборка, "ВесБрутто, КоличествоМест, Количество");
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение веса, объема и количества мест для тех пар Заказ (не FTL)-Маршрутный лист, для которых уже создан ТТД, но не на все грузы
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИтогиПоЗаказу", Истина);
	Запрос.Текст = Документы.уатТТД.ГрузыНеFTLЗаказовНеВТТДТекстЗапроса();
	Запрос.УстановитьПараметр("ЗаказыМаршрутныеЛисты", СозданныеДокументы.Выгрузить(, "Заказ, МаршрутныйЛист, FTL"));
	Запрос.УстановитьПараметр("КоэфВеса", КоэфВеса);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	РезультатЗапроса.Свернуть("Заказ, МаршрутныйЛист", "КоличествоТоваров, КоличествоГрузовыхМест, Количество, КоличествоМест, ВесБрутто, Объем");
	Для Каждого ТекСтрока Из РезультатЗапроса Цикл
		НайденныеСтроки = СозданныеДокументы.НайтиСтроки(Новый Структура("Заказ, МаршрутныйЛист", ТекСтрока.Заказ, ТекСтрока.МаршрутныйЛист));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НоваяСтрока = НовыеДокументы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденныеСтроки[0]);
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока, "КоличествоТоваров, КоличествоГрузовыхМест, Количество, КоличествоМест, ВесБрутто, Объем");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Immediate opening for this object is prohibited!';ru='Непосредственное открытие для данного объекта запрещено!'"), 10);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_НовыеДокументы

&НаКлиенте
Процедура НовыеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	текСтрока = Элементы.НовыеДокументы.ТекущиеДанные;
	Если текСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.НовыеДокументыФлагВыбора Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Заказ, МаршрутныйЛист", текСтрока.Заказ, текСтрока.МаршрутныйЛист);
	ОткрытьФорму("Документ.уатТТД.ФормаОбъекта", ПараметрыФормы,,Новый УникальныйИдентификатор);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_СозданныеДокументы

&НаКлиенте
Процедура СозданныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	текСтрока = Элементы.СозданныеДокументы.ТекущиеДанные;
	Если текСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", текСтрока.ТТД);
	ОткрытьФорму("Документ.уатТТД.ФормаОбъекта", ПараметрыФормы,,Новый УникальныйИдентификатор); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для Каждого ТекЛистИЗаказ из НовыеДокументы Цикл
		ТекЛистИЗаказ.ФлагВыбора = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого ТекЛистИЗаказ из НовыеДокументы Цикл
		ТекЛистИЗаказ.ФлагВыбора = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	НайденныеСтроки = НовыеДокументы.НайтиСтроки(Новый Структура("ФлагВыбора", Истина));
	ЕстьОшибки = Ложь;
	Для Каждого ТекСтрока Из НайденныеСтроки Цикл  
		Если флВыборЭПД Тогда
			Если ЕстьОшибки Тогда
				Прервать;
			КонецЕсли;
			МассивДокументОснование = Новый Массив();
			МассивДокументОснование.Добавить(текСтрока.Заказ); 
			Если ЗначениеЗаполнено(текСтрока.МаршрутныйЛист) Тогда
				МассивДокументОснование.Добавить(текСтрока.МаршрутныйЛист); 
			КонецЕсли;
			
			ДопПараметры = Неопределено;
			Если флВыборFTLЭПД Тогда
				ДопПараметры = Новый Структура("Груз,ПунктОтправления,ПунктНазначения,Грузоотправитель,Грузополучатель,
				|Количество,КоличествоМест,КоличествоТоваров,КоличествоГрузовыхМест,ВесБрутто,Объем,Цена,Сумма"); 
				ЗаполнитьЗначенияСвойств(ДопПараметры, ТекСтрока);
			КонецЕсли;

			уатОбменСГИСЭПДКлиент.СоздатьЭПД(Тип("ДокументСсылка.ЭлектроннаяТранспортнаяНакладная"), МассивДокументОснование, ВладелецФормы, ДопПараметры, ЕстьОшибки);
		Иначе
			ПараметрыФормы = Новый Структура("Заказ, МаршрутныйЛист", текСтрока.Заказ, текСтрока.МаршрутныйЛист);
			ОткрытьФорму("Документ.уатТТД.ФормаОбъекта", ПараметрыФормы,,Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()
	Элементы.НовыеДокументыКонтрагент.Видимость     = флагВыборЗаказа;
	Элементы.СозданныеДокументыКонтрагент.Видимость = флагВыборЗаказа;
	Элементы.НовыеДокументыДоговор.Видимость        = флагВыборЗаказа;
	Элементы.СозданныеДокументыДоговор.Видимость    = флагВыборЗаказа;
	Элементы.НовыеДокументыПеревозчик.Видимость     = флагВыборМаршрутногоЛиста ИЛИ флВыборЭПД;
	Элементы.СозданныеДокументыПеревозчик.Видимость = флагВыборМаршрутногоЛиста;
	Элементы.НовыеДокументыТС.Видимость             = флВыборЭПД;
	Элементы.НовыеДокументыВодитель.Видимость       = флВыборЭПД;
	Элементы.НовыеДокументыГруз.Видимость           = флВыборЭПД И флВыборFTLЭПД;
	Элементы.НовыеДокументыГрузоотправитель.Видимость = флВыборЭПД И флВыборFTLЭПД;
	Элементы.НовыеДокументыГрузополучатель.Видимость  = флВыборЭПД И флВыборFTLЭПД;
	Элементы.НовыеДокументыПунктОтправления.Видимость = флВыборЭПД И флВыборFTLЭПД;
	Элементы.НовыеДокументыПунктНазначения.Видимость  = флВыборЭПД И флВыборFTLЭПД;
	
	Если флВыборЭПД Тогда
		Элементы.НовыеДокументыКоличествоТоваров.Видимость      = Ложь;
		Элементы.НовыеДокументыКоличествоГрузовыхМест.Видимость = Ложь;
		Элементы.НовыеДокументыКоличество.Видимость             = Ложь;
		Элементы.НовыеДокументыКоличествоМест.Видимость         = Ложь; 
		Элементы.НовыеДокументыВес.Видимость                    = Ложь;
		Элементы.НовыеДокументыОбъем.Видимость                  = Ложь;
	КонецЕсли;     
	
	Элементы.ГруппаСозданныеДокументы.Видимость = СозданныеДокументы.Количество() > 0;
	
	Если флагВыборЗаказа Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Выберите Заказ на ТС' ; en = 'Select trucking order'");
	ИначеЕсли флагВыборМаршрутногоЛиста Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Выберите Маршрутный лист' ; en = 'Select routing list'"); 
	ИначеЕсли флВыборЭПД Тогда 
		Элементы.НовыеДокументыМаршрутныйЛист.Заголовок = НСтр("ru='Рейс' ;");

		ЭтаФорма.Заголовок = НСтр("ru='Выберите связанные документы' ;");
	КонецЕсли;
	
КонецПроцедуры;

#КонецОбласти