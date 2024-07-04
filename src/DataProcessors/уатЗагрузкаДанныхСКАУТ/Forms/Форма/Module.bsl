
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// начало блока стандартных операций
	ДопПараметрыОткрытие = Новый Структура("ИмяФормы", ИмяФормы);
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
	Если Не Константы.уатИспользоватьСКАУТ.Получить() Тогда
		ТекстСообщения = НСтр("en='Opening is possible only when enabled using of satellite monitoring system SKAUT.';ru='Открытие возможно только тогда, когда включено использование системы спутникового мониторинга - СКАУТ.'");
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстСообщения, Отказ);
	КонецЕсли;
	
	ВосстановитьНастройки();
	
	ПроизвольныйПериод         = Новый СтандартныйПериод;
	ПроизвольныйПериод.Вариант = ВариантСтандартногоПериода.Вчера;
	Объект.ДатаС               = ПроизвольныйПериод.ДатаНачала;
	Объект.ДатаПо              = ПроизвольныйПериод.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// начало блока стандартных операций
	уатЗащищенныеФункцииКлиент.уатОбработкаФормаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда 
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТС

&НаКлиенте
Процедура ТСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Состояние(НСтр("ru = 'Добавлено ТС'") + " <" + Строка(ВыбранноеЗначение) + ">",,, БиблиотекаКартинок.Информация32);
	
	НайдСтроки = ТС.НайтиСтроки(Новый Структура("Ссылка", ВыбранноеЗначение));
	Если НайдСтроки.Количество() = 0 Тогда 
		НовСтрока = ТС.Добавить();
		НовСтрока.Ссылка = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	
	ТекстОшибки = "";
	Отказ = Ложь;
	
	Если ТС.Количество() = 0 Тогда 
		ТекстОшибки = НСтр("en='Not selected any vehicle';ru='Не выбрано ни одного ТС'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"ТС",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаС) Тогда 
		ТекстОшибки = НСтр("en='Not filled start date of download';ru='Не заполнена дата начала загрузки'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"Объект.ДатаС",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаПо) Тогда 
		ТекстОшибки = НСтр("en='Not filled end date of download';ru='Не заполнена дата окончания загрузки'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"Объект.ДатаПо",,Отказ);
	КонецЕсли;
	
	Если Объект.ДатаС > Объект.ДатаПо Тогда 
		ТекстОшибки = НСтр("en='Download start date cannot be greater than end date';ru='Дата начала загрузки не может быть больше даты окончания'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"Объект.ДатаС",,Отказ);
	КонецЕсли;
	
	Если Не ЗагрузитьПробегИРасходГСМ И Не ЗагрузитьДополнительныеСведения И Не ЗагрузитьКоординаты Тогда 
		ТекстОшибки = НСтр("en='You must select at least one option to download (mileage and consumption/additional information)';ru='Необходимо выбрать хотя бы один параметр для загрузки (пробег и расход/дополнительные сведения/координаты)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"ЗагрузитьПробегИРасходГСМ",,Отказ);
	КонецЕсли;
	
	// Выполним загрузку
	Если Не Отказ Тогда
		ИнициализацияФормыДлительнойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ПроизвольныйПериод               = Новый СтандартныйПериод;
	ПроизвольныйПериод.Вариант       = ВариантСтандартногоПериода.ПроизвольныйПериод;
	ПроизвольныйПериод.ДатаНачала    = Объект.ДатаС;
	ПроизвольныйПериод.ДатаОкончания = Объект.ДатаПо;
	
	ДиалогВыбораПериода        = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогВыбораПериода.Период = ПроизвольныйПериод;
	
	ДиалогВыбораПериода.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТС(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.уатТС.ФормаВыбора", ПараметрыФормы, Элементы.ТС,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсемиТС(Команда)
	
	Если ТС.Количество() Тогда 
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ЗаполнитьВсемиТСОчистка", ЭтотОбъект),
			НСтр("en='You want to clear the table before filling?';ru='Очистить таблицу перед заполнением?'"),
			РежимДиалогаВопрос.ДаНетОтмена
		);
		
	Иначе 
		ЗаполнитьВсемиТСЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенноеЗаполнение(Команда)
	
	Если ТС.Количество() Тогда 
		ПоказатьВопрос(
			Новый ОписаниеОповещения("РасширенноеЗаполнениеОчистка", ЭтотОбъект),
			НСтр("en='You want to clear the table before filling?';ru='Очистить таблицу перед заполнением?'"),
			РежимДиалогаВопрос.ДаНетОтмена
		);
		
	Иначе 
		РасширенноеЗаполнениеУстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицуТС(Команда)
	
	Если ТС.Количество() Тогда 
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОчиститьТаблицуТСОчистка", ЭтотОбъект),
			НСтр("en='You want to clear the table?';ru='Очистить таблицу?'"),
			РежимДиалогаВопрос.ДаНет
		);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыВыводаФормыДлительнойОперации

&НаКлиенте
Процедура ИнициализацияФормыДлительнойОперации()

	ДлительнаяОперация = ВыполнениеОбработкиНаСервере();
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания       = Истина;
	НастройкиОжидания.ВыводитьПрогрессВыполнения = Истина;

	Обработчик = Новый ОписаниеОповещения("ПроверитьВыполнениеЗадания", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);

КонецПроцедуры

&НаСервере
Функция ВыполнениеОбработкиНаСервере()
	
	ТаблТС   = ТС.Выгрузить(,"Ссылка");
	МассивТС = ТаблТС.ВыгрузитьКолонку("Ссылка");
	
	КодВозврата = 0;
	
	ДатаНачала    = Объект.ДатаС;
	ДатаОкончания = Объект.ДатаПо;
	ТекущаяДата   = ТекущаяДатаСеанса();
	
	Если ДатаНачала > ТекущаяДата Тогда 
		ДатаНачала = ТекущаяДата;
	КонецЕсли;
	
	Если ДатаОкончания > ТекущаяДата Тогда 
		ДатаОкончания = ТекущаяДата;
	КонецЕсли;
	
	Если ДатаНачала >= ДатаОкончания Тогда 
		Возврат КодВозврата;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура("ВнешняяСистема,ДатаНачала,ДатаОкончания,МассивТС,
	|ЗагрузитьПробегРасход,ЗагрузитьДопСведения,ЗагрузитьКоординаты");
	ПараметрыПроцедуры.ВнешняяСистема         = Справочники.уатВнешниеСистемы.СКАУТ;
	ПараметрыПроцедуры.ДатаНачала             = ДатаНачала;
	ПараметрыПроцедуры.ДатаОкончания          = ДатаОкончания;
	ПараметрыПроцедуры.МассивТС               = МассивТС;
	ПараметрыПроцедуры.ЗагрузитьПробегРасход  = ЗагрузитьПробегИРасходГСМ;
	ПараметрыПроцедуры.ЗагрузитьДопСведения   = ЗагрузитьДополнительныеСведения;
	ПараметрыПроцедуры.ЗагрузитьКоординаты    = ЗагрузитьКоординаты;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Загрузка данных СКАУТ';en='Loading data SCOUT'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;

	Возврат ДлительныеОперации.ВыполнитьВФоне(
	"уатМониторинг.ЗагрузитьДанныеИзСистемыМониторингаДлительнаяОперация",
	ПараметрыПроцедуры,
	ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПроверитьВыполнениеЗадания(Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция = Неопределено Тогда
		
	Иначе
		Если Операция.Статус = "Выполнено" Тогда
			Если ЭтоАдресВременногоХранилища(Операция.АдресРезультата) Тогда
				Данные = ПолучитьИзВременногоХранилища(Операция.АдресРезультата);
				Если ТипЗнч(Данные) = Тип("Структура") Тогда
					КодВозврата = Данные.КодВозврата;
					ЕстьОшибки  = Данные.ЕстьОшибки;
					
					Если КодВозврата = 0 
						И НЕ ЕстьОшибки Тогда 
						ТекстПредупреждения = НСтр("en='Download data completed successfully';ru='Загрузка данных завершена успешно'");
						ПоказатьПредупреждение(, ТекстПредупреждения);
						
					Иначе 
						ТекстПредупреждения = Новый ФорматированнаяСтрока(
						НСтр("ru = 'Загрузка данных завершена успешно.'"),
						Символы.ПС,
						Символы.ПС,
						НСтр("ru = 'При загрузке данных возникли ошибки.'"),
						Символы.ПС,
						НСтр("ru = 'Перейти в'"),
						" """,
						Новый ФорматированнаяСтрока(НСтр("ru='Журнал регистрации';en='Event log'"),,,, "e1cib/app/Обработка.ЖурналРегистрации"),
						"""."
						);
						
						ПоказатьПредупреждение(, ТекстПредупреждения);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		Иначе
			ВызватьИсключение Операция.КраткоеПредставлениеОшибки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ВосстановитьНастройки()
	
	СтруктураНастроек = Неопределено;
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда 
		СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить(
			"Обработка.уатЗагрузкаДанныхСКАУТ", 
			"НастройкиЗагрузки"
		);
	КонецЕсли;
	
	Если СтруктураНастроек = Неопределено Тогда 
		СтруктураНастроек = Новый Структура();
	КонецЕсли;
	
	Если Не СтруктураНастроек.Свойство("ЗагрузитьПробегИРасходГСМ") Тогда 
		СтруктураНастроек.Вставить("ЗагрузитьПробегИРасходГСМ", Истина);
	КонецЕсли;
	Если Не СтруктураНастроек.Свойство("ЗагрузитьДополнительныеСведения") Тогда 
		СтруктураНастроек.Вставить("ЗагрузитьДополнительныеСведения", Истина);
	КонецЕсли;
	Если Не СтруктураНастроек.Свойство("ЗагрузитьКоординаты") Тогда 
		СтруктураНастроек.Вставить("ЗагрузитьКоординаты", Истина);
	КонецЕсли;
	Если Не СтруктураНастроек.Свойство("СписокТС") Тогда 
		СтруктураНастроек.Вставить("СписокТС", Новый Массив());
	КонецЕсли;
	
	ЗагрузитьПробегИРасходГСМ       = СтруктураНастроек.ЗагрузитьПробегИРасходГСМ;
	ЗагрузитьДополнительныеСведения = СтруктураНастроек.ЗагрузитьДополнительныеСведения;
	ЗагрузитьКоординаты             = СтруктураНастроек.ЗагрузитьКоординаты;
	
	Для Каждого ТекТС Из СтруктураНастроек.СписокТС Цикл 
		НовСтрока = ТС.Добавить();
		НовСтрока.Ссылка = ТекТС;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = Новый Структура();
	СтруктураНастроек.Вставить("ЗагрузитьПробегИРасходГСМ",       ЗагрузитьПробегИРасходГСМ);
	СтруктураНастроек.Вставить("ЗагрузитьДополнительныеСведения", ЗагрузитьДополнительныеСведения);
	СтруктураНастроек.Вставить("ЗагрузитьКоординаты",             ЗагрузитьКоординаты);
	СтруктураНастроек.Вставить("СписокТС",                        Новый Массив());
	
	Для Каждого ТекСтрока Из ТС Цикл 
		СтруктураНастроек.СписокТС.Добавить(ТекСтрока.Ссылка);
	КонецЦикла;
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Обработка.уатЗагрузкаДанныхСКАУТ", 
		"НастройкиЗагрузки", 
		СтруктураНастроек
	);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДатаС  = Период.ДатаНачала;
	Объект.ДатаПо = Период.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсемиТСОчистка(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		ТС.Очистить();
		ЗаполнитьВсемиТСЗавершение();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда 
		ЗаполнитьВсемиТСЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсемиТСЗавершение()
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатТС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|ГДЕ
	|	НЕ уатТС.ПометкаУдаления
	|	И НЕ уатТС.ЭтоГруппа
	|	И уатТС.ИспользуемаяСистемаGPS = ЗНАЧЕНИЕ(Справочник.уатВнешниеСистемы.СКАУТ)
	|	И НЕ уатТС.ИДвСистемеНавигации = """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		НовСтрока = ТС.Добавить();
		НовСтрока.Ссылка = Выборка.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенноеЗаполнениеОчистка(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		ТС.Очистить();
		РасширенноеЗаполнениеУстановитьОтбор();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда 
		РасширенноеЗаполнениеУстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенноеЗаполнениеУстановитьОтбор()
	
	ОткрытьФорму(
		"ОбщаяФорма.уатФормаПодбораТС", 
		Новый Структура("ИсточникПодбора", "Обработка_уатЗагрузкаДанныхСКАУТ"), 
		ЭтотОбъект,
		,
		,
		,
		Новый ОписаниеОповещения("РасширенноеЗаполнениеЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенноеЗаполнениеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекТС Из РезультатЗакрытия Цикл 
		НовСтрока = ТС.Добавить();
		НовСтрока.Ссылка = ТекТС;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицуТСОчистка(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		ТС.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
