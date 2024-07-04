
#Область ПеременныеОбъекта

Перем мВалютаРегламентированногоУчета Экспорт;//Переменная хранит значение валюты регламентированного учёта,
                                              // полученное из констант
Перем табВыбраннаяНоменклатура Экспорт; //таблица с уже добавленной в таб часть заказы номенклатурой

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Расчитывает итоговые показатели (по кнопке "Рассчитать" внизу формы документа)
//
// Параметры:
//  IDстроки					 - 	 - 
//  ПересчетВремениРасстояния	 - 		 - 
//
Процедура РассчитатьИтоговыеПоказатели(IDстроки, ПересчетВремениРасстояния = Истина, кэшНулевыеРасстоянияМеждуПунктами = Неопределено) Экспорт
	
	ТекСтрокаПункты = ПунктыНазначения.Найти(IDстроки, "ID");
	Если ТекСтрокаПункты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мВесБрутто      = 0; 
	мОбъем          = 0; 
	мКолМест        = 0;
	мСтоимость      = 0;
	мВалютаУпрУчета = Неопределено;
	мВесТары        = 0;
	
	// Цикл по грузам.
	Если ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам
			Или ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда
		
		Для Каждого ТекСтрокаГруз Из ГрузовойСостав Цикл
			Если ТекСтрокаГруз.ID <> ТекСтрокаПункты.ID Тогда
				Продолжить;
			КонецЕсли;
			
			мВесБрутто = мВесБрутто + ТекСтрокаГруз.ВесБрутто;
			мОбъем     = мОбъем     + ТекСтрокаГруз.Объем;
			мКолМест   = мКолМест   + ТекСтрокаГруз.КоличествоМест;
				
			Если ЗначениеЗаполнено(ТекСтрокаГруз.ГрузовоеМесто) Тогда
				ГрузовоеМестоВалюта = ТекСтрокаГруз.ГрузовоеМесто.Валюта;
				Если Не ЗначениеЗаполнено(ГрузовоеМестоВалюта) Тогда //если валюта ГМ не указана, считается что в валюте упр. учета
					Если мВалютаУпрУчета = Неопределено Тогда
						Если уатРаботаСМетаданными.уатЕстьКонстанта("ВалютаУправленческогоУчета") Тогда 
							мВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
						Иначе 
							мВалютаУпрУчета = Константы.ВалютаРегламентированногоУчета.Получить();
						КонецЕсли;
					КонецЕсли;
					ГрузовоеМестоВалюта = мВалютаУпрУчета;
				КонецЕсли;
			Иначе
				ГрузовоеМестоВалюта = ВалютаТоваров;
			КонецЕсли;
			
			мСтоимость = мСтоимость + уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(
				ТекСтрокаГруз.Стоимость, ГрузовоеМестоВалюта, ВалютаТоваров, Дата, Дата); 
				
			Если ТекСтрокаГруз.ГрузовоеМесто.Контейнер Тогда
				ТекСтрокаГруз.ВесТары = ТекСтрокаГруз.ГрузовоеМесто.ВесТары * ТекСтрокаГруз.КоличествоМест;
			ИначеЕсли ЗначениеЗаполнено(ТекСтрокаГруз.ВидУпаковки) Тогда
				ТекСтрокаГруз.ВесТары = ТекСтрокаГруз.ВидУпаковки.ВесТары * ТекСтрокаГруз.КоличествоМест;
			КонецЕсли;
			мВесТары = мВесТары + ТекСтрокаГруз.ВесТары;
		КонецЦикла;
	КонецЕсли;
	
	// Цикл по товарам.
	Если ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам
			Или ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда
		
		Для Каждого ТекСтрокаТовар Из ТоварныйСостав Цикл
			Если ТекСтрокаТовар.ID <> ТекСтрокаПункты.ID Тогда
				Продолжить;
			КонецЕсли;
			
			мВесБрутто = мВесБрутто + ТекСтрокаТовар.ВесБрутто;
			мОбъем     = мОбъем     + ТекСтрокаТовар.Объем;
			мКолМест   = мКолМест   + ТекСтрокаТовар.КоличествоМест;
			
			Если ЗначениеЗаполнено(ТекСтрокаТовар.ГрузовоеМесто) Тогда
				ТекВалюта = ТекСтрокаТовар.ГрузовоеМесто.Валюта;
				Если Не ЗначениеЗаполнено(ТекВалюта) Тогда //если валюта ГМ не указана, считается что в валюте упр. учета
					Если мВалютаУпрУчета = Неопределено Тогда
						Если уатРаботаСМетаданными.уатЕстьКонстанта("ВалютаУправленческогоУчета") Тогда 
							мВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
						Иначе 
							мВалютаУпрУчета = Константы.ВалютаРегламентированногоУчета.Получить();
						КонецЕсли;
					КонецЕсли;
					ТекВалюта = мВалютаУпрУчета;
				КонецЕсли;
			Иначе
				ТекВалюта = ВалютаТоваров;
			КонецЕсли;
			
			СуммаВсего = ТекСтрокаТовар.Сумма + ?(УчитыватьНДС И НЕ СуммаВключаетНДС, ТекСтрокаТовар.СуммаНДС, 0);
			
			мСтоимость = мСтоимость + уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(
				СуммаВсего, ТекВалюта, ВалютаТоваров, Дата, Дата); 
			
			РаспределениеПоУпаковкам = уатОбщегоНазначения_уэ.УпаковатьНоменклатуру(ТекСтрокаТовар.Номенклатура, ТекСтрокаТовар.Количество);
			ТекСтрокаТовар.ВесТары = уатОбщегоНазначения_уэ.ПолучитьВесТарыПоУпаковкам(РаспределениеПоУпаковкам);
			мВесТары = мВесТары + ТекСтрокаТовар.ВесТары;
		КонецЦикла;
	КонецЕсли;
	
	ТекСтрокаПункты.ВесБрутто      = мВесБрутто;
	ТекСтрокаПункты.Объем          = мОбъем; 
	ТекСтрокаПункты.КоличествоМест = мКолМест;
	ТекСтрокаПункты.СтоимостьГруза = мСтоимость;
	ТекСтрокаПункты.ВесТары        = мВесТары;
	
	Если ТекСтрокаПункты.FTL Тогда 
		СтрокиППзаказа = ПромежуточныеПункты.НайтиСтроки(Новый Структура("ID", IDстроки));
		
		Если ПересчетВремениРасстояния Тогда 
			мсвПункты = Новый Массив();
			Для Сч = 0 По СтрокиППзаказа.Количество()-2 Цикл 
				Пункт1 = СтрокиППзаказа[Сч].Пункт;
				Пункт2 = СтрокиППзаказа[(Сч+1)].Пункт;
				
				Если Не ТипЗнч(Пункт1) = Тип("СправочникСсылка.уатПунктыНазначения") Или Не ЗначениеЗаполнено(Пункт1) 
						Или Не ТипЗнч(Пункт2) = Тип("СправочникСсылка.уатПунктыНазначения") Или Не ЗначениеЗаполнено(Пункт2) Тогда 
					Продолжить;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокиППзаказа[Сч].Время) Или ЗначениеЗаполнено(СтрокиППзаказа[Сч].Расстояние) Тогда 
					Продолжить;
				КонецЕсли;
				
				// Используем закэшированную информацию о том, что расстояния равны 0, чтобы не пересчитывать ее
				Если кэшНулевыеРасстоянияМеждуПунктами <> Неопределено Тогда
					СтруктураПоиска = Новый Структура("ПунктОтправления, ПунктНазначения", Пункт1, Пункт2);
					НайденныеСтроки = кэшНулевыеРасстоянияМеждуПунктами.НайтиСтроки(СтруктураПоиска);
					Если НайденныеСтроки.Количество() > 0 Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				мсвПункты.Добавить(Новый Структура("Пункт1, Лат1, Лон1, Пункт2, Лат2, Лон2, ИдентификаторСтрокиПункта, ВремяВыезда",
					Пункт1,,, Пункт2,,, Сч, ТекСтрокаПункты.ОтправлениеС));
			КонецЦикла;
			
			уатЗащищенныеФункцииСервер.РассчитатьТаблицуРасстояниеВремяМеждуПунктами(мсвПункты);
			
			Если Не мсвПункты.Количество() = 0 Тогда 
				Для Каждого ТекСтрока Из мсвПункты Цикл 
					СтрокиППзаказа[ТекСтрока.ИдентификаторСтрокиПункта].Время      = ТекСтрока.Время;
					СтрокиППзаказа[ТекСтрока.ИдентификаторСтрокиПункта].Расстояние = ТекСтрока.Расстояние;
					
					// кэшируем нулевые расстояния между пунктами, чтобы не пересчитывать их потом
					Если кэшНулевыеРасстоянияМеждуПунктами <> Неопределено 
						И ТекСтрока.Время = 0 И ТекСтрока.Расстояние = 0 Тогда
						СтруктураПоиска = Новый Структура("ПунктОтправления, ПунктНазначения", ТекСтрока.Пункт1, ТекСтрока.Пункт2);
						НайденныеСтроки = кэшНулевыеРасстоянияМеждуПунктами.НайтиСтроки(СтруктураПоиска);
						Если НайденныеСтроки.Количество() = 0 Тогда
							НоваяСтрока = кэшНулевыеРасстоянияМеждуПунктами.Добавить();
							НоваяСтрока.ПунктОтправления = СтруктураПоиска.ПунктОтправления;
							НоваяСтрока.ПунктНазначения = СтруктураПоиска.ПунктНазначения;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		мСтоянка    = 0;
		мВремя      = 0;
		мРасстояние = 0;
		
		Для Сч = 0 По СтрокиППзаказа.Количество()-1 Цикл 
			мСтоянка = уатЗащищенныеФункцииСервер.СложитьВремя(мСтоянка, СтрокиППзаказа[Сч].Стоянка);
			
			Если ТипЗнч(СтрокиППзаказа[Сч].Пункт) = Тип("СправочникСсылка.уатПунктыНазначения") Тогда 
				мСтоянка = уатЗащищенныеФункцииСервер.СложитьВремя(мСтоянка, уатОбщегоНазначения.ПолучитьВремяДопСтонки(СтрокиППзаказа[Сч].Пункт));
			КонецЕсли;
			
			мВремя      = уатЗащищенныеФункцииСервер.СложитьВремя(мВремя, СтрокиППзаказа[Сч].Время);
			мРасстояние = мРасстояние + СтрокиППзаказа[Сч].Расстояние;
		КонецЦикла;
		
		ТекСтрокаПункты.Расстояние    = мРасстояние;
		ТекСтрокаПункты.ПробегСГрузом = ТекСтрокаПункты.Расстояние;
		ТекСтрокаПункты.Время         = мВремя;
		ТекСтрокаПункты.Стоянка       = мСтоянка;
		
	Иначе 
		мСтоянка = 0;
		мСтоянка = уатЗащищенныеФункцииСервер.СложитьВремя(ТекСтрокаПункты.СтоянкаПунктОтправления, ТекСтрокаПункты.СтоянкаПунктНазначения);
		
		Если ТипЗнч(ТекСтрокаПункты.АдресОтправления) = Тип("СправочникСсылка.уатПунктыНазначения") Тогда 
			мСтоянка = уатЗащищенныеФункцииСервер.СложитьВремя(мСтоянка, уатОбщегоНазначения.ПолучитьВремяДопСтонки(ТекСтрокаПункты.АдресОтправления));
		КонецЕсли;
		
		Если ТипЗнч(ТекСтрокаПункты.АдресНазначения) = Тип("СправочникСсылка.уатПунктыНазначения") Тогда 
			мСтоянка = уатЗащищенныеФункцииСервер.СложитьВремя(мСтоянка, уатОбщегоНазначения.ПолучитьВремяДопСтонки(ТекСтрокаПункты.АдресНазначения));
		КонецЕсли;
		
		ТекСтрокаПункты.Стоянка = мСтоянка;
		
		Если ПересчетВремениРасстояния Тогда 
			ТекСтрокаПункты.Расстояние = 0;
			ТекСтрокаПункты.ПробегСГрузом = 0;
			ТекСтрокаПункты.Время = 0;
			Если ЗначениеЗаполнено(ТекСтрокаПункты.АдресОтправления) И ЗначениеЗаполнено(ТекСтрокаПункты.АдресНазначения) Тогда
				мсвПункты = Новый Массив();
				мсвПункты.Добавить(Новый Структура("Пункт1, Лат1, Лон1, Пункт2, Лат2, Лон2, ИдентификаторСтрокиПункта, ВремяВыезда, Маршрут", 
					ТекСтрокаПункты.АдресОтправления,,, ТекСтрокаПункты.АдресНазначения,,,, 
					ТекСтрокаПункты.ОтправлениеС, ТекСтрокаПункты.Маршрут));
				
				уатЗащищенныеФункцииСервер.РассчитатьТаблицуРасстояниеВремяМеждуПунктами(мсвПункты);
				
				Если мсвПункты.Количество() Тогда 
					ТекСтрокаПункты.Расстояние = мсвПункты[0].Расстояние;
					ТекСтрокаПункты.ПробегСГрузом = ТекСтрокаПункты.Расстояние;
					ТекСтрокаПункты.Время = мсвПункты[0].Время;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	Отказ = ПроверитьДатыДействия();
	
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
		ПроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	// проверка уникальности грузовых мест
	Если ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
		тблГрузМеста = ГрузовойСостав.Выгрузить().Скопировать();
		тблГрузМеста.Свернуть("ГрузовоеМесто");
		Если тблГрузМеста.Количество() < ГрузовойСостав.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Freight train"" must not be duplicate lines with cargo space!';ru='В табличной части ""Грузовой состав"" не должно быть строк с повторяющимся грузовым местом!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если УчитыватьНДС Тогда
		ПроверяемыеРеквизиты.Добавить("ТоварныйСостав.СтавкаНДС");
		ПроверяемыеРеквизиты.Добавить("Услуги.СтавкаНДС");
		ПроверяемыеРеквизиты.Добавить("Расходы.СтавкаНДС");
	КонецЕсли;
	
	// Проверка заполнения реквизитов "Отрезок пути".
	Если ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам Тогда
		ТаблицаГрузов = ТоварныйСостав;
		ИмяТаблицыГрузов = "ТоварныйСостав";
	ИначеЕсли ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
		ТаблицаГрузов = ГрузовойСостав;
		ИмяТаблицыГрузов = "ГрузовойСостав";
	Иначе
		ТаблицаГрузов = Новый ТаблицаЗначений;
		ИмяТаблицыГрузов = "";
	КонецЕсли;
	мсвОтрезков = уатОбщегоНазначения_проф.ПолучитьНачальныеКонечныеПунктыГрузов(ОтрезкиПути, ТаблицаГрузов.Количество(), ПромежуточныеПункты.Количество());
	
	Для Каждого ТекЗаказ Из ПунктыНазначения Цикл 
		Если ТекЗаказ.FTL И ИмяТаблицыГрузов <> "" Тогда 
			флОтрицательноеОжидание = Ложь;
			
			Для Каждого ТекСтрока Из ПромежуточныеПункты Цикл 
				Если Не ТекСтрока.ID = ТекЗаказ.ID Тогда 
					Продолжить;
				КонецЕсли;
				
				Если ТекСтрока.Ожидание < 0 Тогда 
					флОтрицательноеОжидание = Истина;
				КонецЕсли;
			КонецЦикла;
			
			Если флОтрицательноеОжидание Тогда 
				ТекстОшибки = НСтр("ru = 'В строках таблицы ""Маршрут"" указано отрицательное значение ожидания.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,, Отказ);
			КонецЕсли;
			
			Для Каждого ТекСтрока Из ТаблицаГрузов Цикл 
				Если Не ТекСтрока.ID = ТекЗаказ.ID Тогда 
					Продолжить;
				КонецЕсли;
				
				ТекОтрезок = мсвОтрезков[ТекСтрока.НомерСтроки-1];
				Если ТекОтрезок.До < 0 Или ТекОтрезок.До < 0 Тогда
					Если ЗначениеЗаполнено(ТекСтрока.ОтрезокПути) И уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() Тогда
						ТекстОшибки = НСтр("ru = 'Не заполнен отрезок пути. Возможно, требуется выполнить обработчик отложенного обновления на версию 1.1.9.1'
											|;en = 'Route segment not specified.'");
					ИначеЕсли ЗначениеЗаполнено(ТекСтрока.ОтрезокПути) Тогда
						ТекстОшибки = НСтр("ru = 'Не заполнен. Возможно, требуется выполнить обработчик отложенного обновления на версию 2.2.9.1'
											|;en = 'Route segment not specified.'");
					Иначе
						ТекстОшибки = НСтр("ru = 'Не заполнен отрезок пути.';en = 'Route segment not specified.'");
					КонецЕсли;
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстОшибки,
						ЭтотОбъект,
						ИмяТаблицыГрузов+"["+Формат(ТекСтрока.НомерСтроки - 1, "ЧН=0; ЧГ=0")+"].ПредставлениеОтрезкаПути",
						,
						Отказ
					);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	// проверка наличия строк с одинаковыми услугами и разными валютами
	тблУслугиПоВалютам = Услуги.Выгрузить(, "ID, Номенклатура, Валюта").Скопировать();
	тблУслугиПоВалютам.Свернуть("ID, Номенклатура, Валюта");
	тблУслугиСвернутая = тблУслугиПоВалютам.Скопировать();
	тблУслугиСвернутая.Свернуть("ID, Номенклатура");
	Если тблУслугиПоВалютам.Количество() <> тблУслугиСвернутая.Количество() Тогда
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке("В табличной части ""Доходы"" не должно быть строк с одной номенклатурой, но разными валютами!",
			Отказ, Заголовок);
	КонецЕсли;
	тблУслугиПоВалютам = Расходы.Выгрузить(, "ID, Номенклатура, Валюта").Скопировать();
	тблУслугиПоВалютам.Свернуть("ID, Номенклатура, Валюта");
	тблУслугиСвернутая = тблУслугиПоВалютам.Скопировать();
	тблУслугиСвернутая.Свернуть("ID, Номенклатура");
	Если тблУслугиПоВалютам.Количество() <> тблУслугиСвернутая.Количество() Тогда
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке("В табличной части ""Расходы"" не должно быть строк с одной номенклатурой, но разными валютами!",
			Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда    
		Возврат;
	КонецЕсли;
	
	// дозаполнение колонки ID даты действия в ТЧ Даты действия
	Если Не Отказ Тогда
		Для Каждого ТекСтрока Из ДатыДействия Цикл
			Если ПустаяСтрока(ТекСтрока.IDДатыДействия) Тогда
				ТекСтрока.IDДатыДействия = Новый УникальныйИдентификатор;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не Отказ Тогда 
		Для Каждого ТекСтрокаПункты Из ПунктыНазначения Цикл 
			СтрокиППзаказа = ПромежуточныеПункты.НайтиСтроки(Новый Структура("ID", ТекСтрокаПункты.ID));
			Если ТекСтрокаПункты.FTL И СтрокиППзаказа.Количество() > 1 Тогда 
				СтрокиППзаказа[0].Пункт   = ТекСтрокаПункты.АдресОтправления;
				СтрокиППзаказа[0].Стоянка = ТекСтрокаПункты.СтоянкаПунктОтправления;
				
				СтрокиППзаказа[СтрокиППзаказа.Количество()-1].Пункт   = ТекСтрокаПункты.АдресНазначения;
				СтрокиППзаказа[СтрокиППзаказа.Количество()-1].Стоянка = ТекСтрокаПункты.СтоянкаПунктНазначения;
				
			Иначе 
				Для Каждого ТекСтрока Из СтрокиППзаказа Цикл 
					ПромежуточныеПункты.Удалить(ТекСтрока);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не Отказ И Не Константы.уатИспользоватьМультимодальныеПеревозки_уэ.Получить() Тогда 
		Для Каждого ТекСтрока Из ПунктыНазначения Цикл 
			Если Не ЗначениеЗаполнено(ТекСтрока.ВидПеревозки) Тогда
				ТекСтрока.ВидПеревозки = Справочники.уатВидыПеревозок.АвтомобильнаяГрузовая;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не Отказ И Не ПометкаУдаления Тогда
		Права_ = Неопределено;
		флПересчетИтогов = (уатПраваИНастройки.уатПраво("ПотребностьВПеревозкеПерерасчетИтоговПриПроведении", Права_) = Истина);
		Если флПересчетИтогов Тогда 
			Для Каждого ТекСтрока Из ПунктыНазначения Цикл
				РассчитатьИтоговыеПоказатели(ТекСтрока.ID);
			КонецЦикла;
		КонецЕсли;
		Если Ссылка.Пустая() ИЛИ флПересчетИтогов Тогда
			АвтоматическийПересчетДоходов();
		КонецЕсли;
	КонецЕсли;
	
	Если Не Отказ И ПометкаУдаления Тогда
		НайтиСвязанныеЗаказыНаТС(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не Отказ И Не ПометкаУдаления И ПолучитьФункциональнуюОпцию("уатИспользоватьУведомления_уэ") Тогда
		// Заполнение ТЧ "Получатели уведомлений"
		Если Модифицированность() Тогда
			тблПолучатели = уатОбщегоНазначения_уэ.СформироватьСписокПолучателейУведомлений(ЭтотОбъект);
			ПолучателиУведомлений.Загрузить(тблПолучатели);
		КонецЕсли;
		
		// Отслеживаем событие "Изменение статуса"
		флИзменениеСтатуса = Ссылка.Пустая() Или Ссылка.СтатусВыполнения <> СтатусВыполнения;
		ДополнительныеСвойства.Вставить("флИзменениеСтатуса", флИзменениеСтатуса);
	КонецЕсли;
	
	// заполнение реквизитов многовалютного учета
	Если НЕ Отказ И НЕ Служебный_ВыполненоОтложенноеОбновление_1_1_7_1 Тогда
		Обработки.уатОтложенноеОбновлениеИБ.ЗаполнитьРеквизитыДокументаМноговалютныйУчет_1_1_7_1(ЭтотОбъект);
	КонецЕсли;
	
	// Удаление некорректных отрезков пути
	Если Не Отказ Тогда
		Если ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам Тогда
			КоличествоГрузов = ТоварныйСостав.Количество();
		Иначе
			КоличествоГрузов = ГрузовойСостав.Количество();
		КонецЕсли;
		Сч = ОтрезкиПути.Количество();
		Пока Сч > 0 Цикл
			Сч = Сч-1;
			Если ОтрезкиПути[Сч].Груз > КоличествоГрузов Тогда
				ОтрезкиПути.Удалить(Сч);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда    
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("флИзменениеСтатуса") И ДополнительныеСвойства.флИзменениеСтатуса Тогда
		уатОбщегоНазначения_уэ.СформироватьУведомление(Ссылка, Перечисления.уатТипыСобытийДляУведомления_уэ.ИзменениеСтатуса);
	КонецЕсли;
	
	флИспользованиеШК 	   = уатЗащищенныеФункцииСервер_проф.ИспользоватьШтрихкодированиеОбъекта("уатЗаказГрузоотправителя");
	флИспользуетсяШаблонШК = Константы.уатИспользоватьШаблонШтрихкода_уэ.Получить();
	
	Если флИспользованиеШК И флИспользуетсяШаблонШК И НЕ Отказ Тогда
		
		ДанныеОбъекта = Новый Соответствие();
		ДанныеОбъекта.Вставить("Ссылка", Ссылка);
		
		РеквизитыПотребности = Ссылка.Метаданные().Реквизиты; 
		Для Каждого Реквизит Из РеквизитыПотребности Цикл 		
			ИмяРеквизита = "[Заказ." + Реквизит.Имя + "]";	
			ДанныеОбъекта.Вставить(ИмяРеквизита, Ссылка[Реквизит.Имя]);
		КонецЦикла;
		
		РеквизитыПунктовНазначения = ПунктыНазначения.ВыгрузитьКолонки();
		
		Для Каждого Пункт Из ПунктыНазначения Цикл  
			
			ДанныеОбъекта.Вставить("IDСтрокиПотребности", Пункт.ID);
			ДанныеОбъекта.Вставить("АдресОтправления", Пункт.АдресОтправления);
			ДанныеОбъекта.Вставить("АдресНазначения", Пункт.АдресНазначения);
			
			Для Каждого РеквизитТЧ Из РеквизитыПунктовНазначения.Колонки Цикл
				ИмяРеквизита = "[Заказ." + РеквизитТЧ.Имя + "]";
				ДанныеОбъекта.Вставить(ИмяРеквизита, Пункт[РеквизитТЧ.Имя]);
			КонецЦикла;
			
			СтруктураОтбораСтрок = Новый Структура("ID", Пункт.ID);
			ДанныеОбъекта.Вставить("СтруктураОтбораСтрок", СтруктураОтбораСтрок);
			
			Если ПериодическаяПотребность Тогда
				ПериодыДействия = ДатыДействия.НайтиСтроки(СтруктураОтбораСтрок);
				Для Каждого ТекПериод Из ПериодыДействия Цикл
					ДанныеОбъекта.Вставить("Дата", ТекПериод.ДатаОтправления);
					КодированиеПотребности(ДанныеОбъекта);
				КонецЦикла;
			Иначе	
				ДанныеОбъекта.Вставить("Дата", Дата);
				КодированиеПотребности(ДанныеОбъекта);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	// Обновление ID строк.
	Для Каждого СтрокаПункта Из ПунктыНазначения Цикл 
		СтарыйID = СтрокаПункта.ID;
		НовыйID  = Строка(Новый УникальныйИдентификатор());
		
		СтрокаПункта.ID = НовыйID;
		
		мсвСтрок = ГрузовойСостав.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = ДатыДействия.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = Услуги.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = ТоварныйСостав.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = Расходы.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = Выработка.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = ПромежуточныеПункты.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
		
		мсвСтрок = ОтрезкиПути.НайтиСтроки(Новый Структура("ID", СтарыйID));
		Для Каждого ТекСтрока Из мсвСтрок Цикл 
			ТекСтрока.ID = НовыйID;
		КонецЦикла;
	КонецЦикла;
	НомерВходящегоДокумента = "";
	ДатаВходящегоДокумента  = Дата(1,1,1);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Проверяет корректность заполнения дат действия
// 
// Возвращаемое значение:
//  Истина - зЗаполнено не корректно,
//  Ложь - заполнено корректно.
//
Функция ПроверитьДатыДействия()
	
	Отказ = Ложь;
	
	Если ПериодическаяПотребность Тогда
		Для Каждого ТекСтрока Из ДатыДействия Цикл
			Если ЗначениеЗаполнено(ТекСтрока.ДатаПрибытия) И ЗначениеЗаполнено(ТекСтрока.ДатаОтправления) И ТекСтрока.ДатаОтправления > ТекСтрока.ДатаПрибытия Тогда
				ТекстНСТР = НСтр("en='Date of departure %1 is greater than the arrival date %2 in line %3 of tabular section ""Action dates""';ru='Дата отправления %1 больше даты прибытия %2 в строке %3 табличной части ""Даты действия""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, Формат(ТекСтрока.ДатаОтправления, "ДФ=dd.MM.yy"), Формат(ТекСтрока.ДатаПрибытия, "ДФ=dd.MM.yy"), Строка(ТекСтрока.НомерСтроки));
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
			КонецЕсли;
		КонецЦикла;	                                                                                                            
	Иначе
		Для Каждого ТекСтрока Из ПунктыНазначения Цикл
			Если ЗначениеЗаполнено(ТекСтрока.ДатаПрибытия) И ЗначениеЗаполнено(ТекСтрока.ДатаОтправления) И ТекСтрока.ДатаОтправления > ТекСтрока.ДатаПрибытия Тогда
				ТекстНСТР = НСтр("en='Departure date is %1 greater than arrival date %2 at line %3 of tabular section ""Destinations""';ru='Дата отправления %1 больше даты прибытия %2 в строке %3 табличной части ""Пункты назначения""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, Формат(ТекСтрока.ДатаОтправления, "ДФ=dd.MM.yy"), Формат(ТекСтрока.ДатаПрибытия, "ДФ=dd.MM.yy"), Строка(ТекСтрока.НомерСтроки));
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Процедура АвтоматическийПересчетДоходов()
	флАвторасчетПриСоздании = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		ПользователиКлиентСервер.АвторизованныйПользователь(), "ПотребностьВПеревозкеАвторасчетДоходовПриСоздании");
	Если Ссылка.Пустая() И НЕ флАвторасчетПриСоздании Тогда
		Возврат;
	КонецЕсли;
	
	флИнтерактивно = ДополнительныеСвойства.Свойство("Интерактивно");
	флСообщение = Ложь;
	
	СуммаДоходовСтарая = уатОбщегоНазначенияТиповые.уатПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
	
	флПересчетИтогов = флАвторасчетПриСоздании ИЛИ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		ПользователиКлиентСервер.АвторизованныйПользователь(), "ПотребностьВПеревозкеПерерасчетИтоговПриПроведении");
	
	Если НЕ флПересчетИтогов Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаПункта Из ПунктыНазначения Цикл
		//СтрокиУслугПоПотребности = Услуги.НайтиСтроки(Новый Структура("ID", СтрокаПункта.ID));
		//Если СтрокиУслугПоПотребности.Количество() = 0 Тогда
		//	Продолжить;
		//КонецЕсли;
		
		ДопПараметры = Новый Структура("ЗаполнятьТЧДоходы, ЗаполнятьТЧРасходы", Ложь, Ложь);
		СтруктураДокумента = уатОбщегоНазначенияКлиентСервер.СтруктураДокумента(ЭтотОбъект, "уатПотребностьВПеревозке_уэ", ДопПараметры);
	
		уатРасчетыПоТарифам_уэ.РасчитатьТаблицуУслугВДокументе(СтруктураДокумента, "Услуги",, СтрокаПункта.ID);
		уатРасчетыПоТарифамКлиентСервер_уэ.ЗаполнитьДоходыРасходыИзСтруктуры(ЭтотОбъект, СтруктураДокумента, "Услуги", "уатПотребностьВПеревозке_уэ",, флСообщение, СтрокаПункта.ID);
	КонецЦикла;
	
	СуммаДоходовНовая = уатОбщегоНазначенияТиповые.уатПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
	СуммаДокумента = СуммаДоходовНовая;
	
	Если Не Ссылка.Пустая() И СуммаДоходовНовая <> СуммаДоходовСтарая Тогда 
		Если НЕ флИнтерактивно Тогда //неинтерактивный пересчет, например при групповом проведении документов
			Если флПересчетИтогов Тогда
				ТекстНСТР = НСтр("en='Automatically recalculate tabular section ""Preliminary incomes"" in """ + ЭтотОбъект
					+ """';ru='Выполнен автоматический пересчет табличной части ""Предварительные доходы"" в документе """ + ЭтотОбъект + """'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР, ЭтотОбъект);
			Иначе
				ТекстНСТР = НСтр("en='It is necessary to recalculate of tabular section ""Preliminary incomes"" in """ + ЭтотОбъект
					+ """!';ru='Необходимо выполнить пересчет табличной части ""Предварительные доходы"" в документе """ + ЭтотОбъект + """!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР, ЭтотОбъект);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	ДополнительныеСвойства.Вставить("ПересчетИтогов", флПересчетИтогов);
	Если СуммаДоходовНовая <> СуммаДоходовСтарая Тогда
		ДополнительныеСвойства.Вставить("ВыполненАвтопересчетУслуг");
	КонецЕсли;
	
КонецПроцедуры

Процедура НайтиСвязанныеЗаказыНаТС(Отказ)
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатЗаказГрузоотправителя.Ссылка КАК Ссылка,
		|	уатЗаказГрузоотправителя.Номер КАК Номер,
		|	уатЗаказГрузоотправителя.Дата КАК Дата,
		|	уатЗаказГрузоотправителя.ПометкаУдаления КАК ПометкаУдаления,
		|	уатЗаказГрузоотправителя.ДатаЗакрытия КАК ДатаЗакрытия
		|ИЗ
		|	Документ.уатЗаказГрузоотправителя КАК уатЗаказГрузоотправителя
		|ГДЕ
		|	уатЗаказГрузоотправителя.ДокументОснование = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ТекстНСтр = Нстр("ru = 'Помечены на удаление связанные Заказы на ТС:'");
	ФлагЕстьЗаказы = Ложь;
	РазрешитьРедактирование = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(), "РазрешитьРедактированиеЗакрытыхДокументов");
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если НЕ РазрешитьРедактирование И ВыборкаДетальныеЗаписи.ДатаЗакрытия = '00010101' Тогда
			Если уатЗащищенныеФункцииСервер_уэ.КонтрольОперацийПоЗаказу(ВыборкаДетальныеЗаписи.Ссылка) Тогда 
				ТекстОшибкиНСТР = Строка(ВыборкаДетальныеЗаписи.Ссылка) + " " + НСтр("en='participates in movements. Changing the status of document is prohibited.';ru='участвует в движениях. Изменение состояния документа запрещено.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиНСТР, ЭтотОбъект);
			Иначе
				Попытка
					ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
					ДокументОбъект.УстановитьПометкуУдаления(Истина);
					ТекстНСтр = ТекстНСтр + " " + ВыборкаДетальныеЗаписи.Номер + ",";
					ФлагЕстьЗаказы = Истина;
				Исключение
				КонецПопытки;
			КонецЕсли;
		ИначеЕсли НЕ РазрешитьРедактирование И ВыборкаДетальныеЗаписи.ДатаЗакрытия <> '00010101' Тогда
			ТекстОшибкиНСТР = Строка(ВыборкаДетальныеЗаписи.Ссылка) + " " + НСтр("en='is closed. Posting cancellation is prohibited!';ru='закрыт. Отмена проведения запрещена!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиНСТР, ЭтотОбъект);
		Иначе
			Попытка
				ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
				ДокументОбъект.УстановитьПометкуУдаления(Истина);
				ТекстНСтр = ТекстНСтр + " " + ВыборкаДетальныеЗаписи.Номер + ",";
				ФлагЕстьЗаказы = Истина;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	Если ФлагЕстьЗаказы Тогда
		ТекстНСтр = Лев(ТекстНСтр, СтрДлина(ТекстНСтр) - 1);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР, ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

Процедура КодированиеПотребности(ДанныеОбъекта)
	
	СтруктураОтбораСтрок = ДанныеОбъекта["СтруктураОтбораСтрок"];
	
	Грузы  = ГрузовойСостав.НайтиСтроки(СтруктураОтбораСтрок);
	Товары = ТоварныйСостав.НайтиСтроки(СтруктураОтбораСтрок);
	
	Если ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда
		уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(ДанныеОбъекта,, ДанныеОбъекта["IDСтрокиПотребности"]);
	ИначеЕсли ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
		флИспользованиеШКГрузов = Константы.уатИспользоватьШтрихкодированиеГрузовЗаказахНаТС_уэ.Получить();
		уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(ДанныеОбъекта,, ДанныеОбъекта["IDСтрокиПотребности"]);
		
		Если флИспользованиеШКГрузов Тогда
			ТекСчетчик = 1;
			Для Каждого ТекСтрока Из Грузы Цикл
				Если ТекСтрока.ГрузовоеМесто.ФормированиеШКНаКаждыйЭкземпляр Тогда
					Для Счетчик = 1 По ТекСтрока.КоличествоМест Цикл
						уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(ТекСтрока.ГрузовоеМесто, Ссылка, ТекСтрока.НомерСтроки, ТекСчетчик, ДанныеОбъекта);
						ТекСчетчик = ТекСчетчик + 1;
					КонецЦикла;
				Иначе
					уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(ТекСтрока.ГрузовоеМесто, Ссылка, ТекСтрока.НомерСтроки, ТекСчетчик, ДанныеОбъекта);
					ТекСчетчик = ТекСчетчик + 1;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ДетализацияЗаказов = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам Тогда
		флИспользованиеШКГрузов = Константы.уатИспользоватьШтрихкодированиеГрузовЗаказахНаТС_уэ.Получить();
		уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(ДанныеОбъекта,,ДанныеОбъекта["IDСтрокиПотребности"]);
		
		Если флИспользованиеШКГрузов Тогда
			Для Каждого ТекСтрока Из Товары Цикл
				уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(ТекСтрока.Номенклатура, Ссылка, ТекСтрока.НомерСтроки,, ДанныеОбъекта);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
