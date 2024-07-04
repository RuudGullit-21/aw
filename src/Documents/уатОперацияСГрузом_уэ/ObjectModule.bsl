
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ПроверитьКорректностьДанных(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	Документы.уатОперацияСГрузом_уэ.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Если ОперацияВыполнена Тогда
		уатПроведение_уэ.ОтразитьСтатусыГрузов(ДополнительныеСвойства, Движения, Отказ);
		Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Комплектация
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Разукомплектация
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПереносОстатков
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнере
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнера
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПерегрузкаКонтейнера Тогда
			уатПроведение_уэ.ОтразитьОстаткиГрузовНаСкладеКомплектации(ДополнительныеСвойства, Движения, Отказ);
			уатПроведение_уэ.ОтразитьСкладскоеХранениеГрузов(ДополнительныеСвойства, Движения, Отказ);
		КонецЕсли;
		уатПроведение_уэ.ОтразитьГрузыКПеревозке(ДополнительныеСвойства, Движения, Отказ);
		уатПроведение.ОтразитьЗаказыГрузоотправителей(ДополнительныеСвойства, Движения, Отказ);
		Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнере
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнереВПункте
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнера
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнераВПункте
			Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПерегрузкаКонтейнера Тогда
			уатПроведение_уэ.ОтразитьОстаткиГрузовВКонтейнерах(ДополнительныеСвойства, Движения, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Движения.уатОстаткиГрузовНаСкладеКомплектации_уэ.БлокироватьДляИзменения = Истина;
	
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	Документы.уатОперацияСГрузом_уэ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.уатОперацияСГрузом_уэ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПереносОстатков
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнера
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнераВПункте
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПерегрузкаКонтейнера
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнере
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнереВПункте Тогда
		ИсключитьРеквизитИзПроверкиЗаполнения("ГрузыПослеОперации.Наименование", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверкиЗаполнения("ГрузыПослеОперации.ВидДоставки", ПроверяемыеРеквизиты);
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Комплектация Тогда
		ИсключитьРеквизитИзПроверкиЗаполнения("Контрагент", ПроверяемыеРеквизиты);
	КонецЕсли;
	
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнераВПункте
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнереВПункте Тогда
		// Операция в пункте
		ИсключитьРеквизитИзПроверкиЗаполнения("Склад", ПроверяемыеРеквизиты);
	Иначе
		// Операция на складе
		ИсключитьРеквизитИзПроверкиЗаполнения("Пункт", ПроверяемыеРеквизиты);
		
		// Проверка заполнения адреса склада (для заполнения реквизита АдресОтправления новых Заказов на ТС)
		Если ЗначениеЗаполнено(Склад) Тогда
			МенЗаписи = РегистрыСведений.уатАдресаСкладов_уэ.СоздатьМенеджерЗаписи();
			МенЗаписи.Склад = Склад;
			МенЗаписи.Прочитать();
			АдресСклада = МенЗаписи.Адрес;
			
			Если Не ЗначениеЗаполнено(АдресСклада) Тогда
				Отказ = Истина;
				ТекстНСТР = НСтр("en='Address of warehouse ""%1"" empty';ru='Для склада ""%1"" не заполнен адрес'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, Склад);
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Проверка заполнения контейнерных реквизитов
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Комплектация
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПереносОстатков
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Разукомплектация Тогда
		ИсключитьРеквизитИзПроверкиЗаполнения("Контейнер", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверкиЗаполнения("ЗаказНаКонтейнер", ПроверяемыеРеквизиты);
	ИначеЕсли ОперацияВыполнена И Не Контейнер.УникальноеГрузовоеМесто Тогда
		ТекстНСТР = НСтр("en='This operation can only be performed for unique containers';
			|ru='Данная операция может быть выполнена только для уникального контейнера'");
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПерегрузкаКонтейнера Тогда
		ИсключитьРеквизитИзПроверкиЗаполнения("ЗаказНаКонтейнерНовый", ПроверяемыеРеквизиты);
	КонецЕсли;
	
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнера
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ИзвлечениеГрузаИзКонтейнераВПункте Тогда
		ПроверяемыеРеквизиты.Добавить("ГрузыПослеОперации.Заказ");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда    
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПереносОстатков Тогда
		Для Каждого СтрокаТаблицы Из ГрузыПослеОперации Цикл
			Если СтрокаТаблицы.Заказ.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
				Если СтрокаТаблицы.Заказ.ГрузовойСостав.Найти(СтрокаТаблицы.ГрузовоеМесто) = Неопределено Тогда
					ТекстНСТР = НСтр("en='Cargo ""%1"" not found in order ""%2""';ru='Груз ""%1"" не найден в заказе ""%2"" '");
					ТекстНСТР = СтрШаблон(ТекстНСТР, СтрокаТаблицы.ГрузовоеМесто, СтрокаТаблицы.Заказ);
					уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
					Отказ = Истина;
				КонецЕсли;
			ИначеЕсли СтрокаТаблицы.Заказ.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоТоварам Тогда
				Если СтрокаТаблицы.Заказ.Товары.Найти(СтрокаТаблицы.ГрузовоеМесто) = Неопределено Тогда
					ТекстНСТР = НСтр("en='Cargo ""%1"" not found in order ""%2""';ru='Груз ""%1"" не найден в заказе ""%2"" '");
					ТекстНСТР = СтрШаблон(ТекстНСТР, СтрокаТаблицы.ГрузовоеМесто, СтрокаТаблицы.Заказ);
					уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	// Программное создание из формы акта отгрузки
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	// Очистка результирующих заказов
	Для Каждого ТекСтрока Из ЭтотОбъект.ГрузыПослеОперации Цикл
		ТекСтрока.Заказ = Документы.уатЗаказГрузоотправителя.ПустаяСсылка();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ВыполнитьОперацию() Экспорт
	
	// Сначала дозаполняем документ.
	ДокументМодифицирован = Ложь;
	Если Не ЗначениеЗаполнено(ОкончаниеОперации) Тогда
		ОкончаниеОперации = ТекущаяДата();
		ДокументМодифицирован = Истина;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Комплектация
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Разукомплектация Тогда
		
		// Создаем новые грузовые места для новых грузов
		Для Каждого СтрокаГруза Из ГрузыПослеОперации Цикл
			Если Не ЗначениеЗаполнено(СтрокаГруза.ГрузовоеМесто) Тогда
				НовоеГрузовоеМесто = Справочники.уатГрузовыеМеста_уэ.СоздатьЭлемент();
				ЗаполнитьЗначенияСвойств(НовоеГрузовоеМесто, СтрокаГруза);
				НовоеГрузовоеМесто.Записать();
				СтрокаГруза.ГрузовоеМесто = НовоеГрузовоеМесто.Ссылка;
				ДокументМодифицирован = Истина;
			КонецЕсли;
		КонецЦикла;
		
		// Создаем новые заказы для новых грузов
		Для Каждого СтрокаГруза Из ГрузыПослеОперации Цикл
			Если Не ЗначениеЗаполнено(СтрокаГруза.Заказ) Тогда
				НовыйЗаказ = ПолучитьНовыйЗаказ(СтрокаГруза.ПрибытиеС, СтрокаГруза.ПрибытиеПо, СтрокаГруза.АдресНазначения, 
					СтрокаГруза.Грузополучатель, СтрокаГруза.ВидДоставки);
				Если Не НовыйЗаказ.Пустая() Тогда
					СтрокаГруза.Заказ = НовыйЗаказ;
					ДокументМодифицирован = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	// Сначала просто сохраняем документ, чтобы полученные выше данные не потерялись при ошибках проведения
	Если ДокументМодифицирован Тогда
		Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	// Затем проводим документ
	ПредыдущийСтатусВыполнения = СтатусВыполнения;
	Попытка
		ОперацияВыполнена = Истина;
		СтатусВыполнения = Справочники.уатСтатусы_уэ.Выполнен;
		Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ОперацияВыполнена = Ложь;
		СтатусВыполнения = ПредыдущийСтатусВыполнения;
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьКорректностьДанных(Отказ)
	Если (ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Комплектация
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.ПереносОстатков
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Разукомплектация
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнере
		Или ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.РазмещениеГрузаВКонтейнереВПункте)
		И ГрузыДоОперации.Количество() = 0 Тогда
		ТекстНСтр = НСтр("ru = 'В таблице Грузы не указан ни один груз.';" 
				+ "en = 'No cargo selected.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСтр);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Комплектация Тогда
		Если ГрузыПослеОперации.Количество() <> 1 Тогда
			ТекстНСтр = НСтр("ru = 'В результате комплектации должно получиться 1 грузовое место.';"
				+ "en = 'There should be 1 cargo space in the second table.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСтр);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	ИначеЕсли ВидОперации = Перечисления.уатВидыОперацийОперацияСГрузом_уэ.Разукомплектация Тогда
		Если ГрузыДоОперации.Количество() <> 1 Тогда
			ТекстНСтр = НСтр("ru = 'Разукомплектовываться должно 1 грузовое место.';"
				+ "en = 'There should be 1 cargo space in the first table.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСтр);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		// Разукомплектация предусмотрена только для заказов с детализацией по грузовым местам.
		Если ГрузыДоОперации[0].Заказ.ДетализацияЗакрытия <> Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
			ТекстНСтр = НСтр("ru = 'Разукомплектация предусмотрена только для Заказов с детализацией по грузовым местам.';"
				+ "en = 'Wrong order closing details.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСтр);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьНовыйЗаказ(ПрибытиеС, ПрибытиеПо, АдресНазначения, Грузополучатель, ВидДоставки)
	
	СуществующийЗаказ = НайтиЗаказ(ПрибытиеС, ПрибытиеПо, АдресНазначения);
	Если ЗначениеЗаполнено(СуществующийЗаказ) Тогда
		Возврат СуществующийЗаказ;
	КонецЕсли;
	
	Если ГрузыДоОперации.Количество() = 0 Тогда
		Возврат Документы.уатЗаказГрузоотправителя.ПустаяСсылка();
	КонецЕсли;
	
	НовыйЗаказ = Документы.уатЗаказГрузоотправителя.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(НовыйЗаказ, ГрузыДоОперации[0].Заказ, ,"Номер");
	НовыйЗаказ.Дата = ТекущаяДата();
	НовыйЗаказ.ДокументОснование = Ссылка;
	
	НовыйЗаказ.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам;
	НовыйЗаказ.ВидДоставки = Перечисления.уатВидыДоставки_уэ.СкладСклад;
	НовыйЗаказ.FTL = Ложь;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ПрибытиеС", ПрибытиеС);
	ПараметрыОтбора.Вставить("ПрибытиеПо", ПрибытиеПо);
	ПараметрыОтбора.Вставить("АдресНазначения", АдресНазначения);
	ПараметрыОтбора.Вставить("Грузополучатель", Грузополучатель);
	ПараметрыОтбора.Вставить("ВидДоставки", ВидДоставки);
	НайденныеСтроки = ГрузыПослеОперации.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаГруза Из НайденныеСтроки Цикл
		СтрокаГрузовогоСоставаЗаказа = НовыйЗаказ.ГрузовойСостав.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаГрузовогоСоставаЗаказа, СтрокаГруза);
	КонецЦикла;
	
	МассивЗаказовРодителей = Новый Массив;
	Для Каждого СтрокаГруза Из ГрузыДоОперации Цикл
		Если МассивЗаказовРодителей.Найти(СтрокаГруза.Заказ.РодительскийЗаказ) = Неопределено Тогда
			МассивЗаказовРодителей.Добавить(СтрокаГруза.Заказ.РодительскийЗаказ);
			Если МассивЗаказовРодителей.Количество() > 1 Тогда
				НовыйЗаказ.Мультимодальный = Ложь;
				НовыйЗаказ.ЭтоЭтап = Ложь;
				НовыйЗаказ.РодительскийЗаказ = Документы.уатЗаказГрузоотправителя.ПустаяСсылка();
				Прервать;
			КонецЕсли;
		КонецЕсли;		
	КонецЦикла;
	
	НовыйЗаказ.ОтправлениеС = ТекущаяДата();
	НовыйЗаказ.ОтправлениеПо = КонецДня(ТекущаяДата());
	НовыйЗаказ.Грузоотправитель = Склад;
	НовыйЗаказ.Грузополучатель = Грузополучатель;
	НовыйЗаказ.ВидДоставки = ВидДоставки;
	
	Если Не Склад.Пустая() Тогда
		МенЗаписи = РегистрыСведений.уатАдресаСкладов_уэ.СоздатьМенеджерЗаписи();
		МенЗаписи.Склад = Склад;
		МенЗаписи.Прочитать();
		НовыйЗаказ.АдресОтправления = МенЗаписи.Адрес;
	КонецЕсли;
	НовыйЗаказ.КонтактноеЛицоГрузоотправителя = Неопределено;
	
	НовыйЗаказ.ДоставкаС = ПрибытиеС;
	НовыйЗаказ.ДоставкаПо = ПрибытиеПо;
	НовыйЗаказ.АдресНазначения = АдресНазначения;
	
	// Если итоги каждый раз автоматически пересчитываются при проведении, то не надо пересчитывать их лишний раз.
	// Иначе - пересчитываем итоги (в частности, время/расстояние по новому заказу)
	флПересчетИтогов = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		ПользователиКлиентСервер.АвторизованныйПользователь(), "ЗаказНаТСПерерасчетИтоговПриПроведении");
	Если Не флПересчетИтогов Тогда
		НовыйЗаказ.РассчитатьИтоговыеПоказатели();
	КонецЕсли;
	
	НовыйЗаказ.Записать(РежимЗаписиДокумента.Проведение);
	
	Для Каждого СтрокаГруза Из НайденныеСтроки Цикл
		СтрокаГруза.Заказ = НовыйЗаказ.Ссылка;
	КонецЦикла;
	
	Возврат Документы.уатЗаказГрузоотправителя.ПустаяСсылка();
	
КонецФункции

Функция НайтиЗаказ(ПрибытиеС, ПрибытиеПо, АдресНазначения)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ПрибытиеС", ПрибытиеС);
	ПараметрыОтбора.Вставить("ПрибытиеПо", ПрибытиеПо);
	ПараметрыОтбора.Вставить("АдресНазначения", АдресНазначения);
	
	НайденныеСтроки = ГрузыПослеОперации.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0].Заказ;
	Иначе
		Возврат Документы.уатЗаказГрузоотправителя.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Процедура ИсключитьРеквизитИзПроверкиЗаполнения(Реквизит, ПроверяемыеРеквизиты)
	
	ИндексУдаляемого = ПроверяемыеРеквизиты.Найти(Реквизит);
	Если Не ИндексУдаляемого = Неопределено Тогда 
		ПроверяемыеРеквизиты.Удалить(ИндексУдаляемого);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
