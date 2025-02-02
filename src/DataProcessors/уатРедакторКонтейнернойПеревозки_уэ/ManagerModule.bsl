#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция СоздатьПеревозкуПоШаблону(ЭтапыПеревозки, ШаблонПеревозки, ПараметрыПеревозки) Экспорт
	
	СекундВДне = 24 * 60 * 60;
	флРазделятьПланФактВАктах = ПолучитьФункциональнуюОпцию("уатРазделятьПланФактВСкладскихАктах_уэ");
	ЭтоКонтейнернаяПеревозка = ПараметрыПеревозки.Свойство("Контейнер");
	ИспользоватьСкладскиеАкты = ПараметрыПеревозки.Свойство("ИспользоватьСкладскиеАкты");
	СозданныеДокументы = Новый Массив;
	
	// Определение этапов, на которых происходят операции размещения и извлечения грузов в контейнере
	// Для обычных (не контейнерных) перевозок таблицы груза нет, грузы заполняются по Заказам - этапам шаблона
	Если ЭтоКонтейнернаяПеревозка Тогда
		Для Каждого ТекСтрока Из ПараметрыПеревозки.ТаблицаГрузов Цикл
			
			Если ТекСтрока.Заказ.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладДверь
				Или ТекСтрока.Заказ.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад Тогда
				АдресОтправления = ТекСтрока.Заказ.АдресОтправления;
			Иначе
				// Поскольку размещение грузов в контейнере возможно только на складе, то в этом случае размещение невозможно
				//СкладОтправления = Неопределено;
				АдресОтправления = Неопределено;
			КонецЕсли;
			
			Если ТекСтрока.Заказ.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьСклад
				Или ТекСтрока.Заказ.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад Тогда
				АдресНазначения = ТекСтрока.Заказ.АдресНазначения;
			Иначе
				// Поскольку извлечение грузов из контейнера возможно только на складе, то в этом случае размещение невозможно
				//СкладНазначения = Неопределено;
				АдресНазначения = Неопределено;
			КонецЕсли;
			
			СтруктураОтбора = Новый Структура("СоздаватьРазмещениеГрузовВКонтейнере, АдресОтправления", Истина, АдресОтправления);
			НайденныеСтроки = ЭтапыПеревозки.НайтиСтроки(СтруктураОтбора);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ТекСтрока.НомерЭтапаРазмещенияВКонтейнере = НайденныеСтроки[0].НомерСтроки;
			КонецЕсли;
			
			СтруктураОтбора = Новый Структура("СоздаватьИзвлечениеГрузовИзКонтейнера, АдресНазначения", Истина, АдресНазначения);
			НайденныеСтроки = ЭтапыПеревозки.НайтиСтроки(СтруктураОтбора);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Если НайденнаяСтрока.НомерСтроки >= ТекСтрока.НомерЭтапаРазмещенияВКонтейнере Тогда
					ТекСтрока.НомерЭтапаИзвлеченияИзКонтейнера = НайденнаяСтрока.НомерСтроки;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	// Родительский мультимодальный Заказ на ТС
	Если ЭтапыПеревозки.Количество() > 0 Тогда
		ДатаОтправленияРодительскогоЗаказа = ЭтапыПеревозки[0].ДатаОтправления;
		ДатаПрибытияРодительскогоЗаказа    = ЭтапыПеревозки[ЭтапыПеревозки.Количество()-1].ДатаПрибытия;
	Иначе
		ДатаОтправленияРодительскогоЗаказа = ПараметрыПеревозки.ДатаНачалаПеревозки;
		ДатаПрибытияРодительскогоЗаказа    = ПараметрыПеревозки.ДатаНачалаПеревозки;
	КонецЕсли;
	ПараметрыПеревозки.Вставить("ПлановаяДатаОтправленияЗаказа", ДатаОтправленияРодительскогоЗаказа);
	ПараметрыПеревозки.Вставить("ПлановаяДатаПрибытияЗаказа", ДатаПрибытияРодительскогоЗаказа);
	РодительскийЗаказ = СоздатьЗаказНаТСПоШаблону(ШаблонПеревозки, ПараметрыПеревозки, СозданныеДокументы);
	Если Не ЗначениеЗаполнено(РодительскийЗаказ) Тогда
		Возврат СозданныеДокументы;
	КонецЕсли;
	
	ВКонтейнереЕстьГрузы = Ложь;
	ПредыдущийЭтапПеревозки = Документы.уатЗаказГрузоотправителя.ПустаяСсылка();
	
	// Этапы мультимодального Заказа на ТС
	Для Каждого ТекЭтап Из ЭтапыПеревозки Цикл
		
		// Этап
		ПараметрыПеревозки.Вставить("ПлановаяДатаОтправленияЭтапа", ТекЭтап.ДатаОтправления);
		ПараметрыПеревозки.Вставить("ПлановаяДатаПрибытияЭтапа", ТекЭтап.ДатаПрибытия);
		ЭтапПеревозки = СоздатьЗаказНаТСПоШаблону(ТекЭтап.Этап, ПараметрыПеревозки, СозданныеДокументы, РодительскийЗаказ);
		
		// Маршрутный лист
		Если ТекЭтап.СоздаватьМаршрутныйЛист Тогда
			
			МаршрутныйЛист = Документы.уатМаршрутныйЛист.СоздатьДокумент();
			МаршрутныйЛист.Заполнить(ЭтапПеревозки);
			МаршрутныйЛист.Дата = ТекущаяДата();
			МаршрутныйЛист.Ответственный = ТекЭтап.Этап.Ответственный;
			МаршрутныйЛист.ПринадлежностьПеревозки = ТекЭтап.ТС.ПринадлежностьТС;
			МаршрутныйЛист.ТС = ТекЭтап.ТС;
			МаршрутныйЛист.Контрагент = ТекЭтап.Перевозчик;
			МаршрутныйЛист.ДоговорКонтрагента = ТекЭтап.ДоговорСПеревозчиком;
			МаршрутныйЛист.ДатаИВремяОтправленияПлан = ТекЭтап.ДатаОтправления;
			
			СтруктураЭкипаж = уатЗащищенныеФункцииСервер.ЭкипажТСсУчетомГрафика(ТекЭтап.ТС, ТекЭтап.ДатаОтправления, ПараметрыПеревозки.Организация);
			МаршрутныйЛист.Водитель1 = СтруктураЭкипаж.Водитель;
			МаршрутныйЛист.Водитель2 = СтруктураЭкипаж.Водитель2;
			МаршрутныйЛист.Сотрудник1 = СтруктураЭкипаж.Сотрудник;
			МаршрутныйЛист.Сотрудник2 = СтруктураЭкипаж.Сотрудник2;
			
			МаршрутныйЛист.ОбновитьВремяРасстояниеМеждуПунктами();
			уатРасчетыПоТарифам_уэ.ЗаполнитьДоходыРасходыПоШаблону(МаршрутныйЛист, ТекЭтап.Этап);
			
			ЗаписатьДокумент(МаршрутныйЛист);
			СозданныеДокументы.Добавить(МаршрутныйЛист.Ссылка);
			
			РегистрыСведений.уатСобытияПоПеревозке_уэ.СоздатьПеревозкуПоШаблону(ТекЭтап.Этап, МаршрутныйЛист.Ссылка);
			уатОбщегоНазначения_проф.СоздатьСопроводительныеДокументыПоШаблону(МаршрутныйЛист.Ссылка, ТекЭтап.Этап);
			
		КонецЕсли;
		
		// Операция с грузом - перегрузка контейнера. Создавать не требуется, так как
		// не требуется перегружать контейнеры между этапами мультимодального Заказа на ТС
		
		// Операция с грузом - размещение грузов в контейнере
		Если ИспользоватьСкладскиеАкты И ЭтоКонтейнернаяПеревозка И ТекЭтап.СоздаватьРазмещениеГрузовВКонтейнере Тогда
			
			СтрокиРазмещаемыхГрузов = Новый Массив;
			Для Каждого ТекСтрокаГруза Из ПараметрыПеревозки.ТаблицаГрузов Цикл
				Если ТекСтрокаГруза.НомерЭтапаРазмещенияВКонтейнере = ТекЭтап.НомерСтроки Тогда
					СтрокиРазмещаемыхГрузов.Добавить(ТекСтрокаГруза);
				КонецЕсли;
			КонецЦикла;
			
			Если СтрокиРазмещаемыхГрузов.Количество() > 0 Тогда
				ВКонтейнереЕстьГрузы = Истина;
				
				ОперацияСГрузом = Документы.уатОперацияСГрузом_уэ.СоздатьДокумент();
				ОперацияСГрузом.Дата = ТекущаяДата();
				ОперацияСГрузом.Ответственный = ТекЭтап.Этап.Ответственный;
				ОперацияСГрузом.ПлановаяДатаОперации = ТекЭтап.ДатаОтправления;
				ОперацияСГрузом.Организация = ПараметрыПеревозки.Организация;
				Если (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладДверь Или
					ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад) Тогда
					ОперацияСГрузом.ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнере;
					ОперацияСГрузом.Склад = ТекЭтап.Этап.Грузоотправитель;
				Иначе
					ОперацияСГрузом.ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнереВПункте;
					ОперацияСГрузом.Пункт = ТекЭтап.АдресОтправления;
				КонецЕсли;
				ОперацияСГрузом.Контейнер = ПараметрыПеревозки.Контейнер;
				ОперацияСГрузом.ЗаказНаКонтейнер = ЭтапПеревозки;
				
				Для Каждого ТекСтрокаГруза Из СтрокиРазмещаемыхГрузов Цикл
					НоваяСтрокаГруза = ОперацияСГрузом.ГрузыДоОперации.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаГруза, ТекСтрокаГруза);
				КонецЦикла;
				
				ЗаписатьДокумент(ОперацияСГрузом);
				СозданныеДокументы.Добавить(ОперацияСГрузом.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
		// Операция с грузом - извлечение грузов из контейнера
		Если ИспользоватьСкладскиеАкты И ЭтоКонтейнернаяПеревозка И ТекЭтап.СоздаватьИзвлечениеГрузовИзКонтейнера Тогда
			
			СтрокиИзвлекаемыхГрузов = Новый Массив;
			Для Каждого ТекСтрокаГруза Из ПараметрыПеревозки.ТаблицаГрузов Цикл
				Если ТекСтрокаГруза.НомерЭтапаИзвлеченияИзКонтейнера = ТекЭтап.НомерСтроки Тогда
					СтрокиИзвлекаемыхГрузов.Добавить(ТекСтрокаГруза);
				КонецЕсли;
			КонецЦикла;
			
			Если СтрокиИзвлекаемыхГрузов.Количество() > 0 Тогда
				ОперацияСГрузом = Документы.уатОперацияСГрузом_уэ.СоздатьДокумент();
				ОперацияСГрузом.Дата = ТекущаяДата();
				ОперацияСГрузом.Ответственный = ТекЭтап.Этап.Ответственный;
				ОперацияСГрузом.ПлановаяДатаОперации = ТекЭтап.ДатаПрибытия;
				ОперацияСГрузом.Организация = ПараметрыПеревозки.Организация;
				Если (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьСклад Или
					ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад) Тогда
					ОперацияСГрузом.ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнера;
					ОперацияСГрузом.Склад = ТекЭтап.Этап.Грузополучатель;
				Иначе
					ОперацияСГрузом.ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнераВПункте;
					ОперацияСГрузом.Пункт = ТекЭтап.АдресНазначения;
				КонецЕсли;
				ОперацияСГрузом.Контейнер = ПараметрыПеревозки.Контейнер;
				ОперацияСГрузом.ЗаказНаКонтейнер = ЭтапПеревозки;
				
				Для Каждого ТекСтрокаГруза Из СтрокиИзвлекаемыхГрузов Цикл
					НоваяСтрокаГруза = ОперацияСГрузом.ГрузыПослеОперации.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаГруза, ТекСтрокаГруза);
					НоваяСтрокаГруза.ВидУпаковки = ТекСтрокаГруза.ЕдиницаИзмерения;
				КонецЦикла;
				
				ЗаписатьДокумент(ОперацияСГрузом);
				СозданныеДокументы.Добавить(ОперацияСГрузом.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
		// Акт отгрузки
		Если ИспользоватьСкладскиеАкты И ТекЭтап.СоздаватьАктОтгрузки Тогда
			АктОтгрузки = Документы.уатАктОтгрузки_уэ.СоздатьДокумент();
			АктОтгрузки.Заполнить(ЭтапПеревозки);
			
			Если (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьДверь Или
				ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьСклад)
				И ТекЭтап.СоздаватьМаршрутныйЛист Тогда
				
				ВидОперацииВыбран = Истина;
				АктОтгрузки.ВидОперации = Перечисления.уатВидыОперацийАктОтгрузки_уэ.ВРейсВПункте;
				АктОтгрузки.Пункт = ТекЭтап.Этап.АдресОтправления;
				АктОтгрузки.Водитель1 = МаршрутныйЛист.Водитель1;
				АктОтгрузки.МаршрутныйЛист = МаршрутныйЛист.Ссылка;
				АктОтгрузки.Перевозчик = ТекЭтап.Перевозчик;
				АктОтгрузки.ПринадлежностьПеревозки = МаршрутныйЛист.ПринадлежностьПеревозки;
			ИначеЕсли (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладДверь Или
				ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад)
				И ТекЭтап.СоздаватьМаршрутныйЛист Тогда
				
				ВидОперацииВыбран = Истина;
				АктОтгрузки.ВидОперации = Перечисления.уатВидыОперацийАктОтгрузки_уэ.ВРейс;
				АктОтгрузки.Склад = ТекЭтап.Этап.Грузоотправитель;
				АктОтгрузки.Водитель1 = МаршрутныйЛист.Водитель1;
				АктОтгрузки.МаршрутныйЛист = МаршрутныйЛист.Ссылка;
				АктОтгрузки.Перевозчик = ТекЭтап.Перевозчик;
				АктОтгрузки.ПринадлежностьПеревозки = МаршрутныйЛист.ПринадлежностьПеревозки;
			ИначеЕсли (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладДверь Или
				ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад)
				И Не ТекЭтап.СоздаватьМаршрутныйЛист Тогда
				
				ВидОперацииВыбран = Истина;
				АктОтгрузки.ВидОперации = Перечисления.уатВидыОперацийАктОтгрузки_уэ.ПрочееСписание;
				АктОтгрузки.Склад = ТекЭтап.Этап.Грузоотправитель;
			Иначе
				ВидОперацииВыбран = Ложь;
			КонецЕсли;
			
			Если ВидОперацииВыбран Тогда
				АктОтгрузки.Дата = ТекущаяДата();
				АктОтгрузки.Ответственный = ТекЭтап.Этап.Ответственный;
				АктОтгрузки.ПлановаяДатаОперации = ТекЭтап.ДатаОтправления;
				
				Если ЭтоКонтейнернаяПеревозка Тогда
					НоваяСтрока = АктОтгрузки.Грузы.Добавить();
					НоваяСтрока.Заказ = ЭтапПеревозки;
					НоваяСтрока.ГрузовоеМесто = ПараметрыПеревозки.Контейнер;
					НоваяСтрока.ЕдиницаИзмерения = ПараметрыПеревозки.Контейнер.ТипКонтейнера;
					Если флРазделятьПланФактВАктах Тогда
						НоваяСтрока.КоличествоПлан = 1;
					Иначе
						НоваяСтрока.Количество = 1;
					КонецЕсли;
					НоваяСтрока.Статус = Документы.уатАктОтгрузки_уэ.СтатусНовогоГруза(АктОтгрузки.ВидОперации);
				Иначе
					
					// Все грузы по этапу
					Запрос = Новый Запрос("ВЫБРАТЬ
					|	уатЗаказыГрузоотправителейОбороты.ГрузовоеМесто КАК ГрузовоеМесто,
					|	уатЗаказыГрузоотправителейОбороты.Номенклатура КАК Номенклатура,
					|	уатЗаказыГрузоотправителейОбороты.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
					|	уатЗаказыГрузоотправителейОбороты.ЗаказГрузоотправителя КАК ЗаказГрузоотправителя
					|ИЗ
					|	РегистрНакопления.уатЗаказыГрузоотправителей.Обороты(, , , ЗаказГрузоотправителя = &Заказ) КАК уатЗаказыГрузоотправителейОбороты");
					Запрос.УстановитьПараметр("Заказ", ЭтапПеревозки);
					Выборка = Запрос.Выполнить().Выбрать();
					Пока Выборка.Следующий() Цикл
						НоваяСтрока = АктОтгрузки.Грузы.Добавить();
						НоваяСтрока.Заказ = ЭтапПеревозки;
						Если ЭтапПеревозки.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
							НоваяСтрока.ГрузовоеМесто = Выборка.ГрузовоеМесто;
						ИначеЕсли ЭтапПеревозки.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам Тогда
							НоваяСтрока.ГрузовоеМесто = Выборка.Номенклатура;
						КонецЕсли;
						НоваяСтрока.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
						НоваяСтрока.Статус = Документы.уатАктОтгрузки_уэ.СтатусНовогоГруза(АктОтгрузки.ВидОперации);
					КонецЦикла;
					
					АктОтгрузки.ЗаполнитьВесоОбъемныеПоказателиПлан();
				КонецЕсли;
				
				ЗаписатьДокумент(АктОтгрузки);
				СозданныеДокументы.Добавить(АктОтгрузки.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
		// Акт приемки
		Если ИспользоватьСкладскиеАкты И ТекЭтап.СоздаватьАктПриемки Тогда
			АктПриемки = Документы.уатАктПриемки_уэ.СоздатьДокумент();
			АктПриемки.Заполнить(ЭтапПеревозки);
			
			Если (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьДверь Или
				ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладДверь)
				И ТекЭтап.СоздаватьМаршрутныйЛист Тогда
				
				ВидОперацииВыбран = Истина;
				АктПриемки.ВидОперации = Перечисления.уатВидыОперацийАктПриемки_уэ.ИзРейсаВПункте;
				АктПриемки.Пункт = ТекЭтап.Этап.АдресНазначения;
				АктПриемки.МаршрутныйЛист = МаршрутныйЛист.Ссылка;
			ИначеЕсли (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьСклад Или
				ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад)
				И ТекЭтап.СоздаватьМаршрутныйЛист Тогда
				
				ВидОперацииВыбран = Истина;
				АктПриемки.ВидОперации = Перечисления.уатВидыОперацийАктПриемки_уэ.ИзРейса;
				АктПриемки.Склад = ТекЭтап.Этап.Грузополучатель;
				АктПриемки.МаршрутныйЛист = МаршрутныйЛист.Ссылка;
			ИначеЕсли (ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.ДверьСклад Или
				ТекЭтап.Этап.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад)
				И Не ТекЭтап.СоздаватьМаршрутныйЛист Тогда
				
				ВидОперацииВыбран = Истина;
				АктПриемки.ВидОперации = Перечисления.уатВидыОперацийАктПриемки_уэ.ПрочееПоступление;
				АктПриемки.Склад = ТекЭтап.Этап.Грузополучатель;
			Иначе
				ВидОперацииВыбран = Ложь;
			КонецЕсли;
			
			Если ВидОперацииВыбран Тогда
				АктПриемки.Дата = ТекущаяДата();
				АктПриемки.Ответственный = ТекЭтап.Этап.Ответственный;
				АктПриемки.ПлановаяДатаОперации = ТекЭтап.ДатаПрибытия;
				
				// Грузы уже были заполнены в функции Заполнить()
				
				ЗаписатьДокумент(АктПриемки);
				СозданныеДокументы.Добавить(АктПриемки.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
		// Комплект документов
		Если ЗначениеЗаполнено(ТекЭтап.НастройкаФормированияКомплектовДокументов) Тогда
			ДокументыКомплекта = уатРаботаСУведомлениями_уэ.СформироватьКомплектыДокументовПоНастройке(
				ТекЭтап.НастройкаФормированияКомплектовДокументов, ЭтапПеревозки);
			Для Каждого ТекДокумент Из ДокументыКомплекта Цикл
				СозданныеДокументы.Добавить(ТекДокумент.Объект);
			КонецЦикла;
		КонецЕсли;
		
		ПредыдущийЭтапПеревозки = ЭтапПеревозки;
		
	КонецЦикла;
	
	Возврат СозданныеДокументы;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

Функция СоздатьЗаказНаТСПоШаблону(ШаблонЗаказа, ПараметрыПеревозки, СозданныеДокументы, РодительскийЗаказ = Неопределено)
	
	ЭтоКонтейнернаяПеревозка = ПараметрыПеревозки.Свойство("Контейнер");
	
	ЗаказНаТС = Документы.уатЗаказГрузоотправителя.СоздатьДокумент();
	Если ЗначениеЗаполнено(РодительскийЗаказ) Тогда
		ЗаказНаТС.ДополнительныеСвойства.Вставить("ЗаполнениеЭтапаПоРодительскомуЗаказу", Истина);
		ЗаказНаТС.Заполнить(РодительскийЗаказ);
	КонецЕсли;
	ЗаказНаТС.Дата = ТекущаяДата();
	ЗаказНаТС.Организация = ПараметрыПеревозки.Организация;
	ЗаказНаТС.Контрагент = ПараметрыПеревозки.Заказчик;
	Если ТипЗнч(ЗаказНаТС.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
		ЗаказНаТС.ДоговорКонтрагента = ПараметрыПеревозки.ДоговорКонтрагента;
	КонецЕсли;
	ЗаказНаТС.Подразделение = ПараметрыПеревозки.Подразделение;
	
	ЗаполнитьЗначенияСвойств(ЗаказНаТС, ШаблонЗаказа, "АдресНазначения, АдресОтправления,
		|ВалютаДокумента, ВалютаТоваров, ВидГрузаДляДоверенности, ВидДоставки, ВидОперации, ВидПеревозки,
		|Грузоотправитель, Грузополучатель, ДатаКурса, КонтактноеЛицоГрузоотправителя, КонтактноеЛицоГрузополучателя,
		|КратностьВзаиморасчетов, КурсВзаиморасчетов, Маршрут, Мультимодальный, НазваниеГруза,
		|НаправлениеПеревозки, ОбъектСтроительства, Ответственный, СуммаВключаетНДС,
		|Стоянка, СтоянкаПунктОтправления, СтоянкаПунктНазначения, ТипЦен,
		|ТребованиеКТС, ТребованиеКТСТипТС, УчитыватьНДС");
	
	Если ЗначениеЗаполнено(РодительскийЗаказ) Тогда
		ЗаказНаТС.ОтправлениеС  = НачалоДня(ПараметрыПеревозки.ПлановаяДатаОтправленияЭтапа) + (ШаблонЗаказа.ОтправлениеС  - НачалоДня(ШаблонЗаказа.ОтправлениеС));
		ЗаказНаТС.ОтправлениеПо = НачалоДня(ПараметрыПеревозки.ПлановаяДатаОтправленияЭтапа) + (ШаблонЗаказа.ОтправлениеПо - НачалоДня(ШаблонЗаказа.ОтправлениеПо));
		ЗаказНаТС.ДоставкаС     = НачалоДня(ПараметрыПеревозки.ПлановаяДатаПрибытияЭтапа)    + (ШаблонЗаказа.ДоставкаС     - НачалоДня(ШаблонЗаказа.ДоставкаС));
		ЗаказНаТС.ДоставкаПо    = НачалоДня(ПараметрыПеревозки.ПлановаяДатаПрибытияЭтапа)    + (ШаблонЗаказа.ДоставкаПо    - НачалоДня(ШаблонЗаказа.ДоставкаПо));
	Иначе
		ЗаказНаТС.ОтправлениеС  = НачалоДня(ПараметрыПеревозки.ПлановаяДатаОтправленияЗаказа) + (ШаблонЗаказа.ОтправлениеС  - НачалоДня(ШаблонЗаказа.ОтправлениеС));
		ЗаказНаТС.ОтправлениеПо = НачалоДня(ПараметрыПеревозки.ПлановаяДатаОтправленияЗаказа) + (ШаблонЗаказа.ОтправлениеПо - НачалоДня(ШаблонЗаказа.ОтправлениеПо));
		ЗаказНаТС.ДоставкаС     = НачалоДня(ПараметрыПеревозки.ПлановаяДатаПрибытияЗаказа)    + (ШаблонЗаказа.ДоставкаС     - НачалоДня(ШаблонЗаказа.ДоставкаС));
		ЗаказНаТС.ДоставкаПо    = НачалоДня(ПараметрыПеревозки.ПлановаяДатаПрибытияЗаказа)    + (ШаблонЗаказа.ДоставкаПо    - НачалоДня(ШаблонЗаказа.ДоставкаПо));
	КонецЕсли;
	
	Если ЭтоКонтейнернаяПеревозка И Не ЗначениеЗаполнено(РодительскийЗаказ) Тогда
		ЗаказНаТС.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам;
		НоваяСтрока = ЗаказНаТС.ГрузовойСостав.Добавить();
		НоваяСтрока.ГрузовоеМесто = ПараметрыПеревозки.Контейнер;
		НоваяСтрока.ВидУпаковки = ПараметрыПеревозки.Контейнер.ТипКонтейнера;
		НоваяСтрока.КоличествоМест = 1;
		НоваяСтрока.Длина = ПараметрыПеревозки.Контейнер.Длина;
		НоваяСтрока.Ширина = ПараметрыПеревозки.Контейнер.Ширина;
		НоваяСтрока.Высота = ПараметрыПеревозки.Контейнер.Высота;
	ИначеЕсли Не ЭтоКонтейнернаяПеревозка Тогда
		ЗаказНаТС.ДетализацияЗакрытия = ШаблонЗаказа.ДетализацияЗакрытия;
		ЗаказНаТС.ГрузовойСостав.Очистить();
		Для Каждого ТекГруз Из ШаблонЗаказа.ГрузовойСостав Цикл 
			НовГруз = ЗаказНаТС.ГрузовойСостав.Добавить();
			ЗаполнитьЗначенияСвойств(НовГруз, ТекГруз);
		КонецЦикла;
		ЗаказНаТС.Товары.Очистить();
		Для Каждого ТекТовар Из ШаблонЗаказа.Товары Цикл 
			НовТовар = ЗаказНаТС.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НовТовар, ТекТовар);
		КонецЦикла;
	КонецЕсли;
	
	уатРасчетыПоТарифам_уэ.ЗаполнитьДоходыРасходыПоШаблону(ЗаказНаТС, ШаблонЗаказа);
	
	ЗаписатьДокумент(ЗаказНаТС);
	СозданныеДокументы.Добавить(ЗаказНаТС.Ссылка);
	
	Если ЗначениеЗаполнено(РодительскийЗаказ) Тогда
		уатЗащищенныеФункцииСервер_уэ.ЗаписатьПлановыеДатыЭтапов(РодительскийЗаказ, ЗаказНаТС.Ссылка, 
			ПараметрыПеревозки.ПлановаяДатаОтправленияЭтапа, ПараметрыПеревозки.ПлановаяДатаПрибытияЭтапа);
	КонецЕсли;
	
	РегистрыСведений.уатСобытияПоПеревозке_уэ.СоздатьПеревозкуПоШаблону(ШаблонЗаказа, ЗаказНаТС.Ссылка);
	уатОбщегоНазначения_проф.СоздатьСопроводительныеДокументыПоШаблону(ЗаказНаТС.Ссылка, ШаблонЗаказа);
	
	Возврат ЗаказНаТС.Ссылка;
	
КонецФункции

Процедура ЗаписатьДокумент(ДокументОбъект)
	
	ТекстОшибки = НСтр("ru = 'При создании документа ""%1"" возникли ошибки. Документ записан без проведения'");
	
	ЕстьОшибкиЗаполнения = Не ДокументОбъект.ПроверитьЗаполнение();
	Если ЕстьОшибкиЗаполнения Тогда 
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстОшибки, Строка(ДокументОбъект)));
	Иначе
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстОшибки, Строка(ДокументОбъект)));
			ОбщегоНазначения.СообщитьПользователю(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли